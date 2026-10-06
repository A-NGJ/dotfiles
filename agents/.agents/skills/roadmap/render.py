# /// script
# requires-python = ">=3.9"
# dependencies = ["python-pptx>=1.0"]
# ///
"""Render a roadmap data file into Markdown, HTML, and PowerPoint.

Usage: uv run render.py roadmap.json --out DIR [--format md,html,pptx] [--template corp.pptx]
"""

from __future__ import annotations

import argparse
import datetime as dt
import html
import json
import sys
from pathlib import Path

WEEK = dt.timedelta(weeks=1)


# --- data ------------------------------------------------------------------------------


class Roadmap:
    def __init__(self, data: dict):
        self.title = data.get("title", "Roadmap")
        self.as_of = _date(data.get("as_of") or dt.date.today().isoformat(), "as_of")
        window = data.get("window") or {}
        start = _date(window.get("start") or (self.as_of - 2 * WEEK).isoformat(), "window.start")
        self.start = start - dt.timedelta(days=start.weekday())  # weeks start on Monday
        self.weeks = [self.start + i * WEEK for i in range(int(window.get("weeks", 12)))]
        self.end = self.weeks[-1] + dt.timedelta(days=6)
        self.milestones = []
        for i, m in enumerate(data.get("milestones", [])):
            where = f"milestones[{i}]"
            for key in ("theme", "name", "start", "finish"):
                if not m.get(key):
                    sys.exit(f"{where}: missing {key}")
            ms = {
                "theme": m["theme"],
                "name": m["name"],
                "start": _date(m["start"], f"{where}.start"),
                "finish": _date(m["finish"], f"{where}.finish"),
                "start_estimated": bool(m.get("start_estimated")),
                "finish_estimated": bool(m.get("finish_estimated")),
            }
            if ms["finish"] < ms["start"]:
                sys.exit(f"{where}: finish is before start")
            self.milestones.append(ms)
        self.milestones.sort(key=lambda m: (m["start"], m["finish"]))
        self.unscheduled = data.get("unscheduled", [])
        self.themes = list(dict.fromkeys(m["theme"] for m in self.milestones))
        self.visible = [m for m in self.milestones if m["finish"] >= self.start and m["start"] <= self.end]
        self.outside = [m for m in self.milestones if m not in self.visible]

    def col(self, day: dt.date) -> int:
        """Index of the week column holding `day`, clamped to the window."""
        return min(max((day - self.start).days // 7, 0), len(self.weeks) - 1)

    def span(self, m) -> tuple[int, int]:
        return self.col(m["start"]), self.col(m["finish"])

    def rows(self, theme: str) -> list[list[dict]]:
        """Pack a theme's visible milestones into rows so overlapping ones stack."""
        rows: list[list[dict]] = []
        for m in (m for m in self.visible if m["theme"] == theme):
            for row in rows:
                if self.span(row[-1])[1] < self.span(m)[0]:
                    row.append(m)
                    break
            else:
                rows.append([m])
        return rows

    def lanes(self):
        return [(t, self.rows(t)) for t in self.themes if self.rows(t)]

    def today_offset(self) -> float | None:
        """Position of as_of across the window as a fraction, or None when outside it."""
        if not self.start <= self.as_of <= self.end:
            return None
        return (self.as_of - self.start).days / (7 * len(self.weeks))


def _date(value: str, where: str) -> dt.date:
    try:
        return dt.date.fromisoformat(value)
    except (TypeError, ValueError):
        sys.exit(f"{where}: expected YYYY-MM-DD, got {value!r}")


def short(day: dt.date) -> str:
    return f"{day.day} {day:%b}"


def dates(m) -> str:
    s = ("~" if m["start_estimated"] else "") + short(m["start"])
    f = ("~" if m["finish_estimated"] else "") + short(m["finish"])
    return f"{s} – {f}"


def estimated(m) -> bool:
    return m["start_estimated"] or m["finish_estimated"]


def as_of_line(r: Roadmap) -> str:
    return f"As of {short(r.as_of)} {r.as_of.year}. Weeks start on Monday. ~ marks an estimated date."


def unscheduled_lines(r: Roadmap) -> list[str]:
    return [f"{u.get('name', '?')}" + (f" ({u['theme']})" if u.get("theme") else "") for u in r.unscheduled]


# --- Markdown --------------------------------------------------------------------------


def _md_escape(text: str) -> str:
    return text.replace("|", "\\|")


def render_md(r: Roadmap) -> str:
    out = [f"# {r.title}", "", f"_{as_of_line(r)}_", ""]
    out.append("| Theme | " + " | ".join(short(w) for w in r.weeks) + " |")
    out.append("|---|" + "---|" * len(r.weeks))
    for theme, rows in r.lanes():
        for i, row in enumerate(rows):
            cells = [""] * len(r.weeks)
            for m in row:
                a, b = r.span(m)
                cells[a] = f"**{_md_escape(m['name'])}**"
                for j in range(a + 1, b + 1):
                    cells[j] = "▬"
            out.append(f"| {_md_escape(theme) if i == 0 else ''} | " + " | ".join(cells) + " |")
    out += ["", "## Milestones", ""]
    for theme, _ in r.lanes():
        out += [f"**{theme}**", ""]
        out += [f"- {m['name']}: {dates(m)}" for m in r.visible if m["theme"] == theme]
        out.append("")
    if r.outside:
        out += ["## Outside this window", ""]
        out += [f"- {m['name']} ({m['theme']}): {dates(m)}" for m in r.outside]
        out.append("")
    if r.unscheduled:
        out += ["## Unscheduled", ""]
        out += [f"- {line}" for line in unscheduled_lines(r)]
        out.append("")
    return "\n".join(out)


# --- HTML ------------------------------------------------------------------------------

CSS = """
body{font:14px/1.4 -apple-system,system-ui,"Segoe UI",sans-serif;margin:24px;color:#1d2330}
h1{margin:0 0 4px} h2{font-size:16px;margin:24px 0 8px} .asof{color:#667;margin-bottom:20px}
.sl{--lane:140px;position:relative;display:grid;grid-template-columns:var(--lane) repeat(var(--n),1fr);border:1px solid #dde}
.sl-h{font-size:12px;color:#667;padding:6px 4px;border-bottom:1px solid #dde;border-left:1px solid #eef}
.sl-lane{grid-column:1;font-weight:600;padding:10px;border-top:1px solid #dde;background:#f6f7fb;display:flex;align-items:center}
.sl-row{display:grid;grid-template-columns:repeat(var(--n),1fr);border-top:1px solid #eef;padding:6px 0;
  background:repeating-linear-gradient(90deg,transparent 0,transparent calc(100%/var(--n) - 1px),#eef calc(100%/var(--n) - 1px),#eef calc(100%/var(--n)))}
.bar{position:relative;z-index:1;margin:0 3px;padding:6px 8px;border-radius:6px;background:#3b6fd8;color:#fff;overflow:hidden;white-space:nowrap}
.bar span{display:block;font-size:11px;opacity:.85}
.bar.est{color:#1d2330;background:repeating-linear-gradient(45deg,#c5d3f3,#c5d3f3 6px,#b3c5ef 6px,#b3c5ef 12px);outline:1.5px dashed #3b6fd8;outline-offset:-1.5px}
.today{position:absolute;top:0;bottom:0;width:2px;background:#e0503c}
@media print{.sl{break-inside:avoid}}
"""


def render_html(r: Roadmap) -> str:
    e = html.escape
    n = len(r.weeks)
    grid = [f'<div class="sl" style="--n:{n}">', '<div class="sl-h"></div>']
    grid += [f'<div class="sl-h">{short(w)}</div>' for w in r.weeks]
    for theme, rows in r.lanes():
        grid.append(f'<div class="sl-lane" style="grid-row:span {len(rows)}">{e(theme)}</div>')
        for row in rows:
            grid.append(f'<div class="sl-row" style="grid-column:2 / span {n}">')
            for m in row:
                a, b = r.span(m)
                cls = "bar est" if estimated(m) else "bar"
                grid.append(
                    f'<div class="{cls}" style="grid-column:{a + 1} / {b + 2}" title="{e(m["name"])}: {dates(m)}">'
                    f"<b>{e(m['name'])}</b><span>{dates(m)}</span></div>"
                )
            grid.append("</div>")
    offset = r.today_offset()
    if offset is not None:
        grid.append(f'<div class="today" title="{short(r.as_of)}" style="left:calc(var(--lane) + (100% - var(--lane)) * {offset:.4f})"></div>')
    grid.append("</div>")
    extra = []
    if r.outside:
        extra.append("<h2>Outside this window</h2><ul>")
        extra += [f"<li>{e(m['name'])} ({e(m['theme'])}): {dates(m)}</li>" for m in r.outside]
        extra.append("</ul>")
    if r.unscheduled:
        extra.append("<h2>Unscheduled</h2><ul>")
        extra += [f"<li>{e(line)}</li>" for line in unscheduled_lines(r)]
        extra.append("</ul>")
    return (
        f'<!doctype html><html lang="en"><head><meta charset="utf-8"><title>{e(r.title)}</title>'
        f"<style>{CSS}</style></head><body><h1>{e(r.title)}</h1>"
        f'<div class="asof">{e(as_of_line(r))} Light, dashed bars have an estimated date.</div>'
        + "\n".join(grid + extra)
        + "</body></html>\n"
    )


# --- PowerPoint ------------------------------------------------------------------------


def render_pptx(r: Roadmap, path: Path, template: Path | None) -> None:
    from pptx import Presentation
    from pptx.dml.color import RGBColor
    from pptx.enum.dml import MSO_LINE_DASH_STYLE, MSO_THEME_COLOR
    from pptx.enum.shapes import MSO_SHAPE
    from pptx.enum.text import MSO_ANCHOR, PP_ALIGN
    from pptx.util import Emu, Inches, Pt

    prs = Presentation(str(template)) if template else Presentation()
    if template:  # keep the masters and layouts, drop the template's own slides
        ids = prs.slides._sldIdLst
        for sld in list(ids):
            prs.part.drop_rel(sld.rId)
            ids.remove(sld)
    else:
        prs.slide_width, prs.slide_height = Inches(13.333), Inches(7.5)

    def layout():
        by_name = {l.name.lower(): l for l in prs.slide_layouts}
        return by_name.get("title only") or min(prs.slide_layouts, key=lambda l: len(l.placeholders))

    def new_slide(title: str):
        slide = prs.slides.add_slide(layout())
        if slide.shapes.title is not None:
            slide.shapes.title.text = title
            t = slide.shapes.title
            if not template:
                t.left, t.top, t.width, t.height = margin, Inches(0.3), W - 2 * margin, Inches(0.8)
                t.text_frame.paragraphs[0].font.size = Pt(28)
            return slide, t.top + t.height
        box = slide.shapes.add_textbox(margin, Inches(0.3), W - 2 * margin, Inches(0.8))
        box.text_frame.text = title
        box.text_frame.paragraphs[0].font.size = Pt(28)
        return slide, Inches(1.1)

    def text(slide, x, y, w, h, value, size, bold=False, color=None, anchor=MSO_ANCHOR.MIDDLE):
        box = slide.shapes.add_textbox(x, y, w, h)
        tf = box.text_frame
        tf.word_wrap, tf.vertical_anchor = True, anchor
        tf.margin_left = tf.margin_right = Inches(0.04)
        tf.margin_top = tf.margin_bottom = 0
        p = tf.paragraphs[0]
        p.text = value
        p.font.size, p.font.bold = Pt(size), bold
        if color is not None:
            p.font.color.rgb = color
        return box

    def rect(slide, x, y, w, h, rgb):
        shape = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, x, y, w, h)
        shape.fill.solid()
        shape.fill.fore_color.rgb = rgb
        shape.line.fill.background()
        shape.shadow.inherit = False
        return shape

    W, H = prs.slide_width, prs.slide_height
    margin = Inches(0.4)
    grey, rule, muted = RGBColor(0xF2, 0xF3, 0xF7), RGBColor(0xD9, 0xDC, 0xE6), RGBColor(0x66, 0x66, 0x77)

    slide, top = new_slide(r.title)
    text(slide, margin, top, W - 2 * margin, Inches(0.35),
         as_of_line(r) + " Light, dashed bars have an estimated date.", 11, color=muted)
    top += Inches(0.45)

    lane_w = Inches(1.5)
    grid_x, grid_w = margin + lane_w, W - 2 * margin - lane_w
    col_w = Emu(int(grid_w / len(r.weeks)))
    head_h = Inches(0.3)
    lanes = r.lanes()
    total_rows = sum(len(rows) for _, rows in lanes) or 1
    row_h = Emu(int(min(Inches(0.62), (H - Inches(0.4) - top - head_h) / total_rows)))
    body_top = top + head_h

    for i, week in enumerate(r.weeks):
        x = grid_x + col_w * i
        text(slide, x, top, col_w, head_h, short(week), 9, color=muted)
        rect(slide, x, body_top, Emu(9525), row_h * total_rows, rule)  # 0.75pt week rule

    offset = r.today_offset()  # drawn before the bars so it sits behind their labels
    if offset is not None:
        rect(slide, grid_x + Emu(int(grid_w * offset)), top, Emu(25400), head_h + row_h * total_rows,
             RGBColor(0xE0, 0x50, 0x3C))

    y = body_top
    for theme, rows in lanes:
        lane = rect(slide, margin, y, lane_w, row_h * len(rows), grey)
        lane.line.color.rgb = rule
        text(slide, margin + Inches(0.08), y, lane_w - Inches(0.1), row_h * len(rows), theme, 12, bold=True)
        for row in rows:
            for m in row:
                a, b = r.span(m)
                pad = Inches(0.03)
                bar = slide.shapes.add_shape(
                    MSO_SHAPE.ROUNDED_RECTANGLE,
                    grid_x + col_w * a + pad, y + Inches(0.05),
                    col_w * (b - a + 1) - 2 * pad, row_h - Inches(0.1),
                )
                bar.adjustments[0] = 0.15
                bar.shadow.inherit = False
                bar.fill.solid()
                bar.fill.fore_color.theme_color = MSO_THEME_COLOR.ACCENT_1
                if estimated(m):  # lighter fill, dashed outline: renders in every viewer
                    bar.fill.fore_color.brightness = 0.4
                    bar.line.color.theme_color = MSO_THEME_COLOR.ACCENT_1
                    bar.line.width = Pt(1.25)
                    bar.line.dash_style = MSO_LINE_DASH_STYLE.DASH
                else:
                    bar.line.fill.background()
                tf = bar.text_frame
                tf.word_wrap, tf.vertical_anchor = True, MSO_ANCHOR.MIDDLE
                tf.margin_left = tf.margin_right = Inches(0.06)
                tf.margin_top = tf.margin_bottom = 0
                name, when = tf.paragraphs[0], tf.add_paragraph()
                name.text, when.text = m["name"], dates(m)
                for p, size, bold in ((name, 10, True), (when, 8, False)):
                    p.alignment = PP_ALIGN.LEFT
                    p.font.size, p.font.bold = Pt(size), bold
                    p.font.color.rgb = RGBColor(0x1D, 0x23, 0x30) if estimated(m) else RGBColor(0xFF, 0xFF, 0xFF)
            y += row_h
        rect(slide, margin, y, W - 2 * margin, Emu(9525), rule)

    sections = [
        ("Outside this window", [f"{m['name']} ({m['theme']}): {dates(m)}" for m in r.outside]),
        ("Unscheduled", unscheduled_lines(r)),
    ]
    sections = [(t, lines) for t, lines in sections if lines]
    if sections:
        slide, top = new_slide(f"{r.title}: not on the timeline")
        box = slide.shapes.add_textbox(margin, top + Inches(0.2), W - 2 * margin, H - top - Inches(0.6))
        tf = box.text_frame
        tf.word_wrap = True
        first = True
        for heading, lines in sections:
            p = tf.paragraphs[0] if first else tf.add_paragraph()
            first = False
            p.text, p.font.bold, p.font.size = heading, True, Pt(16)
            for line in lines:
                q = tf.add_paragraph()
                q.text, q.font.size, q.level = f"• {line}", Pt(13), 1

    prs.save(str(path))


# --- CLI -------------------------------------------------------------------------------


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("data", type=Path, help="roadmap data file (JSON)")
    ap.add_argument("--out", type=Path, required=True, help="output directory")
    ap.add_argument("--format", default="md", help="comma-separated: md, html, pptx (default md)")
    ap.add_argument("--template", type=Path, help="corporate .pptx whose masters and theme to use")
    args = ap.parse_args(argv)

    formats = [f.strip() for f in args.format.split(",") if f.strip()]
    unknown = set(formats) - {"md", "html", "pptx"}
    if unknown:
        ap.error(f"unknown format(s): {', '.join(sorted(unknown))}")
    r = Roadmap(json.loads(args.data.read_text()))
    if not r.milestones:
        sys.exit("no scheduled milestones; nothing to draw")
    args.out.mkdir(parents=True, exist_ok=True)
    stem = args.data.stem
    written = []
    if "md" in formats:
        written.append(args.out / f"{stem}.md")
        written[-1].write_text(render_md(r))
    if "html" in formats:
        written.append(args.out / f"{stem}.html")
        written[-1].write_text(render_html(r))
    if "pptx" in formats:
        written.append(args.out / f"{stem}.pptx")
        render_pptx(r, written[-1], args.template)
    for path in written:
        print(path)
    return 0


if __name__ == "__main__":
    sys.exit(main())
