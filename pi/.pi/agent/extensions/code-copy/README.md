# Code Copy

A local fork of [`@tmustier/pi-code-actions`](https://github.com/tmustier/pi-extensions/tree/main/code-actions), reduced to its copy workflow. The original code is MIT licensed; see `LICENSE`.

Use `/code` to search fenced code blocks and path-like inline snippets from assistant messages, then press Enter to copy the selected raw text.

Arguments:

- `/code` or `/code last` — search the latest assistant message
- `/code all` — search all assistant messages on the current branch
- `/code blocks` — omit inline path snippets
- `/code 2` — directly copy the second result
- `/code limit=50` — cap extracted results
