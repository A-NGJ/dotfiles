---
name: vim-lsp
description: Complete reference for Neovim's vim.lsp API — all functions, arguments, and submodules. Use this skill whenever the user asks about vim.lsp functions, LSP keybindings, LSP configuration, or needs help with any Neovim LSP command. Also use when the user mentions lsp.buf, codelens, inlay hints, semantic tokens, or LSP-related Neovim setup, even if they don't say "vim.lsp" explicitly.
---

## vim.lsp

```lua
vim.lsp.start(config, opts?) -> integer?
vim.lsp.config(name, cfg)
vim.lsp.enable(name, enable?)
vim.lsp.is_enabled(name) -> boolean
vim.lsp.get_client_by_id(client_id) -> vim.lsp.Client?
vim.lsp.get_clients(filter?) -> vim.lsp.Client[]
vim.lsp.status() -> string
vim.lsp.buf_attach_client(bufnr, client_id) -> boolean
vim.lsp.buf_detach_client(bufnr, client_id)
vim.lsp.buf_is_attached(bufnr, client_id) -> boolean
vim.lsp.buf_notify(bufnr, method, params) -> boolean
vim.lsp.buf_request_all(bufnr, method, params, handler) -> cancel_fn
vim.lsp.buf_request_sync(bufnr, method, params, timeout_ms?) -> table?, string?
vim.lsp.formatexpr(opts?) -> integer
vim.lsp.omnifunc(findstart, base)
vim.lsp.tagfunc(pattern, flags) -> table[]
vim.lsp.foldexpr(lnum) -> string
vim.lsp.foldclose(kind, winid?)
vim.lsp.foldtext() -> string
```

## vim.lsp.buf

```lua
vim.lsp.buf.hover(config?)
vim.lsp.buf.declaration(opts?)
vim.lsp.buf.definition(opts?)
vim.lsp.buf.type_definition(opts?)
vim.lsp.buf.implementation(opts?)
vim.lsp.buf.references(context?, opts?)
vim.lsp.buf.code_action(opts?)
vim.lsp.buf.format(opts?)
vim.lsp.buf.rename(new_name?, opts?)
vim.lsp.buf.signature_help(config?)
vim.lsp.buf.document_symbol(opts?)
vim.lsp.buf.workspace_symbol(query?, opts?)
vim.lsp.buf.incoming_calls()
vim.lsp.buf.outgoing_calls()
vim.lsp.buf.typehierarchy(kind)
vim.lsp.buf.document_highlight()
vim.lsp.buf.clear_references()
vim.lsp.buf.add_workspace_folder(workspace_folder?)
vim.lsp.buf.remove_workspace_folder(workspace_folder?)
vim.lsp.buf.list_workspace_folders() -> string[]
```

## vim.lsp.Client

```lua
client:request(method, params, handler?, bufnr?) -> boolean, integer?
client:request_sync(method, params, timeout_ms?, bufnr?) -> {err, result}?, string?
client:notify(method, params) -> boolean
client:cancel_request(id) -> boolean
client:stop(force?)
client:is_stopped() -> boolean
client:on_attach(bufnr)
client:exec_cmd(command, context?, handler?)
client:supports_method(method, bufnr?) -> boolean
```

## vim.lsp.codelens

```lua
vim.lsp.codelens.enable(enable?, filter?)
vim.lsp.codelens.is_enabled(filter?) -> boolean
vim.lsp.codelens.get(filter?) -> table[]
vim.lsp.codelens.run(opts?)
vim.lsp.codelens.on_refresh(err, _, ctx) -> vim.NIL
```

## vim.lsp.inlay_hint

```lua
vim.lsp.inlay_hint.enable(enable?, filter?)
vim.lsp.inlay_hint.is_enabled(filter?) -> boolean
vim.lsp.inlay_hint.get(filter?) -> table[]
vim.lsp.inlay_hint.on_inlayhint(err, result, ctx)
vim.lsp.inlay_hint.on_refresh(err, _, ctx) -> vim.NIL
```

## vim.lsp.semantic_tokens

```lua
vim.lsp.semantic_tokens.enable(enable?, filter?)
vim.lsp.semantic_tokens.is_enabled(filter?) -> boolean
vim.lsp.semantic_tokens.get_at_pos(bufnr?, row?, col?) -> table[]?
vim.lsp.semantic_tokens.force_refresh(bufnr?)
vim.lsp.semantic_tokens.highlight_token(token, bufnr, client_id, hl_group, opts?)
```

## vim.lsp.completion

```lua
vim.lsp.completion.enable(enable, client_id, bufnr, opts?)
vim.lsp.completion.get(opts?)
```

## vim.lsp.document_color

```lua
vim.lsp.document_color.enable(enable?, bufnr?, opts?)
vim.lsp.document_color.is_enabled(bufnr?) -> boolean
vim.lsp.document_color.color_presentation()
```

## vim.lsp.inline_completion

```lua
vim.lsp.inline_completion.enable(enable?, filter?)
vim.lsp.inline_completion.is_enabled(filter?) -> boolean
vim.lsp.inline_completion.get(opts?) -> boolean
vim.lsp.inline_completion.select(opts?)
```

## vim.lsp.linked_editing_range

```lua
vim.lsp.linked_editing_range.enable(enable?, filter?)
```

## vim.lsp.diagnostic

```lua
vim.lsp.diagnostic.on_publish_diagnostics(_, params, ctx)
vim.lsp.diagnostic.on_diagnostic(error, result, ctx)
vim.lsp.diagnostic.on_refresh(err, _, ctx) -> vim.NIL
vim.lsp.diagnostic.from(diagnostics) -> lsp.Diagnostic[]
vim.lsp.diagnostic.get_namespace(client_id, is_pull?) -> integer
```

## vim.lsp.util

```lua
vim.lsp.util.make_position_params(window?, position_encoding?)
vim.lsp.util.make_range_params(window?, position_encoding?)
vim.lsp.util.make_given_range_params(start_pos?, end_pos?, bufnr?, position_encoding?)
vim.lsp.util.make_text_document_params(bufnr?)
vim.lsp.util.make_workspace_params(added, removed)
vim.lsp.util.make_formatting_params(options?)
vim.lsp.util.apply_text_edits(text_edits, bufnr, position_encoding, change_annotations?)
vim.lsp.util.apply_text_document_edit(text_document_edit, index?, position_encoding?, change_annotations?)
vim.lsp.util.apply_workspace_edit(workspace_edit, position_encoding)
vim.lsp.util.show_document(location, position_encoding, opts?)
vim.lsp.util.preview_location(location, opts?) -> bufnr?, winnr?
vim.lsp.util.open_floating_preview(contents, syntax, opts?) -> bufnr, winnr
vim.lsp.util.make_floating_popup_options(width, height, opts?)
vim.lsp.util.convert_input_to_markdown_lines(input, contents?) -> string[]
vim.lsp.util.convert_signature_help_to_markdown_lines(signature_help, ft?, triggers?)
vim.lsp.util.locations_to_items(locations, position_encoding) -> table[]
vim.lsp.util.symbols_to_items(symbols, bufnr?, position_encoding?) -> table[]
vim.lsp.util.buf_highlight_references(bufnr, references, position_encoding)
vim.lsp.util.buf_clear_references(bufnr)
vim.lsp.util.rename(old_fname, new_fname, opts?)
vim.lsp.util.character_offset(buf, row, col, offset_encoding?) -> integer
vim.lsp.util.get_effective_tabstop(bufnr?) -> integer
```

## vim.lsp.protocol

```lua
vim.lsp.protocol.make_client_capabilities() -> lsp.ClientCapabilities
vim.lsp.protocol.resolve_capabilities(server_capabilities) -> lsp.ServerCapabilities?
```

## vim.lsp.log

```lua
vim.lsp.log.get_filename() -> string
vim.lsp.log.set_level(level)
vim.lsp.log.get_level() -> integer
vim.lsp.log.set_format_func(handle)
vim.lsp.log.trace(...)
vim.lsp.log.debug(...)
vim.lsp.log.info(...)
vim.lsp.log.warn(...)
vim.lsp.log.error(...)
```

## vim.lsp.rpc

```lua
vim.lsp.rpc.start(cmd, dispatchers?, extra_spawn_params?)
vim.lsp.rpc.connect(host_or_path, port?) -> fun(dispatchers): PublicClient
vim.lsp.rpc.format_rpc_error(err) -> string
vim.lsp.rpc.rpc_response_error(code, message?, data?) -> lsp.ResponseError
vim.lsp.rpc.create_read_loop(handle_body, on_exit?, on_error?) -> function
```

## vim.lsp.handlers

```lua
vim.lsp.handlers.hover(err, result, ctx, config)
vim.lsp.handlers.signature_help(err, result, ctx, config)
-- Override via: vim.lsp.handlers['method/name'] = function(err, result, ctx, config) end
```
