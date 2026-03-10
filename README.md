# Neovim Configuration

A personal Neovim configuration targeting Neovim 0.11+ built around a modern LSP-first workflow with support for web development, systems programming, and scripting.

---

## Requirements

- Neovim 0.11+
- [lazy.nvim](https://github.com/folke/lazy.nvim) (auto-installed on first launch)
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- `git` for plugin management
- `fzf` for fuzzy finding
- A terminal with true colour support

Optional but expected:

- `tmux` with [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) configured on the tmux side
- `stylua` for Lua formatting
- `prettier` for web formatting
- `ruff` for Python formatting
- `mypy` for Python type checking (installed per-project via uv)
- GHCup for Haskell (`hls` is not installable via Mason)

---

## Structure

```
~/.config/nvim/
├── init.lua                 entry point
├── .luarc.json              lua_ls config scoped to this directory
├── lazy-lock.json           plugin version lockfile
└── lua/
    ├── config/
    │   ├── init.lua         loads options → keymaps → lazy
    │   ├── options.lua      vim.opt settings
    │   ├── keymaps.lua      base keymaps (no plugin dependencies)
    │   └── lazy.lua         lazy.nvim bootstrap
    └── plugins/
        ├── colorscheme.lua  theme
        ├── ui.lua           interface plugins
        ├── lsp.lua          LSP servers, Mason, diagnostics
        ├── completion.lua   blink.cmp
        ├── formatting.lua   conform + nvim-lint
        ├── treesitter.lua   treesitter + autotag
        ├── editor.lua       editing utilities
        ├── navigation.lua   file/buffer navigation
        ├── git.lua          git integration
        ├── typescript.lua   TypeScript-specific tooling
        └── python.lua       Python-specific tooling
```

### Load order

`options.lua` loads before plugins so editor settings are applied first. `keymaps.lua` loads before `lazy.lua` so `<leader>` is set before any plugin registers mappings against it. Plugin-specific keymaps are defined inside each plugin's `config` or `keys` field.

---

## Design Decisions

### Native LSP over plugin wrappers

Uses Neovim's native `vim.lsp.enable()` and `vim.lsp.config()` API (0.11+) rather than configuring servers through `lspconfig.server.setup()`. This keeps server configuration declarative and consistent across all servers.

### blink.cmp over nvim-cmp

blink.cmp is faster, more actively maintained, and has a simpler configuration model. It also provides built-in Rust-based fuzzy matching (`fuzzy.implementation = "prefer_rust"`) and native signature help.

### conform.nvim over formatter.nvim

conform is async-first, supports format-on-save natively, and has a clean `lsp_format = "fallback"` option that automatically uses the LSP formatter for any filetype not explicitly configured.

### oil.nvim over nvim-tree / neo-tree

Oil treats the file explorer as an editable buffer. Directory contents can be manipulated with standard Vim motions — rename with `r`, delete with `dd`, move with cut/paste. This is more ergonomic than a sidebar tree.

### typescript-tools.nvim over ts_ls

typescript-tools communicates with `tsserver` directly, bypassing the LSP translation layer that `ts_ls` adds. This results in significantly faster completions and diagnostics on large TypeScript projects. It also exposes TypeScript-specific code actions (organise imports, add missing imports, go to source definition) that `ts_ls` does not provide.

### basedpyright + ruff + mypy

Three tools with distinct roles:

- **basedpyright** — completions, go-to-definition, hover, navigation. Type checking disabled to avoid conflicts with mypy.
- **ruff** (LSP) — fast inline linting diagnostics as you type.
- **mypy** (via nvim-lint) — strict type checking on save. Run per-project from within the active uv virtualenv.

### htmx LSP restricted to HTML

The htmx LSP advertises `hoverProvider = true` and attaches to TypeScript files by default. This caused it to respond to hover requests before ts_ls, producing empty hover results. Restricting it to `{ "html" }` fixes hover in TypeScript while keeping htmx completions and diagnostics in HTML files.

### SchemaStore for JSON/YAML

`jsonls` and `yamlls` are configured with the full [SchemaStore](https://www.schemastore.org) catalog. This provides completions and validation for `package.json`, `tsconfig.json`, `.eslintrc`, `docker-compose.yml`, GitHub Actions workflows, and hundreds of other config file formats automatically.

### Inlay hints enabled by default

All LSPs that support inlay hints (ts, rust-analyzer, gopls, clangd) have them enabled globally. A toggle at `<leader>ih` lets you hide them when they add too much noise.

### Diagnostic virtual lines, not virtual text

`virtual_lines = true` renders diagnostics on a dedicated line below the code rather than inline. This avoids cluttering the code itself and works better with longer error messages. `virtual_text` is explicitly disabled to prevent duplication.

### Joke cache for btw.nvim

The startup joke is fetched asynchronously and cached to disk. On each launch the previous joke is shown instantly from cache while a new one is fetched in the background for the next session. This avoids blocking startup on a network request.

---

## Plugins

### Theme & UI (`colorscheme.lua`, `ui.lua`)

| Plugin                      | Purpose                                                                                                                                                                                                       |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `navarasu/onedark.nvim`     | Colorscheme. Uses the `darker` style.                                                                                                                                                                         |
| `nvim-mini/mini.icons`      | Icon provider used by oil, fzf-lua, lualine, trouble, and render-markdown.                                                                                                                                    |
| `folke/noice.nvim`          | Routes LSP progress and notifications through a styled UI. Cmdline kept at the bottom (`view = "cmdline"`). Hover and signature disabled since those are handled by custom keymap and blink.cmp respectively. |
| `nvim-lualine/lualine.nvim` | Statusline showing mode, branch, diagnostics, filename, encoding, filetype, progress, clock, and cursor position.                                                                                             |
| `nvimdev/indentmini.nvim`   | Lightweight indent guides.                                                                                                                                                                                    |
| `NvChad/nvim-colorizer.lua` | Inline colour previews for hex codes and CSS colour names.                                                                                                                                                    |
| `letieu/btw.nvim`           | Startup message. Displays a cached programming joke fetched from jokeapi.dev.                                                                                                                                 |

### LSP (`lsp.lua`)

| Plugin                           | Purpose                                                                                                              |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `neovim/nvim-lspconfig`          | Provides default server configurations (root detection, filetypes, cmd). Servers are enabled via `vim.lsp.enable()`. |
| `mason-org/mason.nvim`           | LSP server installer.                                                                                                |
| `mason-org/mason-lspconfig.nvim` | Bridges Mason and lspconfig. `ensure_installed` auto-installs all configured servers on a fresh machine.             |
| `folke/lazydev.nvim`             | Neovim Lua API type definitions for `lua_ls`. Scoped to Lua files only (`ft = "lua"`).                               |
| `b0o/schemastore.nvim`           | Provides the SchemaStore catalog to `jsonls` and `yamlls`.                                                           |

**Enabled servers:**

| Server                     | Language                                     |
| -------------------------- | -------------------------------------------- |
| `hls`                      | Haskell (installed via GHCup, not Mason)     |
| `rust-analyzer`            | Rust                                         |
| `gopls`                    | Go                                           |
| `clangd`                   | C / C++                                      |
| `zls`                      | Zig                                          |
| `asm_lsp`                  | Assembly                                     |
| `ts_ls` / typescript-tools | TypeScript / JavaScript (see typescript.lua) |
| `tailwindcss`              | Tailwind CSS                                 |
| `emmet_language_server`    | HTML / JSX Emmet                             |
| `cssls`                    | CSS                                          |
| `html`                     | HTML                                         |
| `htmx`                     | HTMX (HTML only)                             |
| `bashls`                   | Bash                                         |
| `lua_ls`                   | Lua                                          |
| `vimls`                    | Vimscript (used when maintaining `.vimrc`)   |
| `basedpyright`             | Python (navigation only, type checking off)  |
| `ruff`                     | Python (linting via LSP)                     |
| `jsonls`                   | JSON                                         |
| `yamlls`                   | YAML                                         |

### Completion (`completion.lua`)

| Plugin                         | Purpose                                                                                                                                         |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `saghen/blink.cmp`             | Completion engine. Sources: LSP (score 1000), lazydev (score 100), path, snippets, buffer. Rust fuzzy matching enabled. Signature help enabled. |
| `rafamadriz/friendly-snippets` | Snippet collection loaded by blink.cmp.                                                                                                         |

### Formatting & Linting (`formatting.lua`)

| Plugin                   | Purpose                                                                                                                                               |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `stevearc/conform.nvim`  | Format on save. Uses `stylua` for Lua, `ruff_format` for Python, `prettier` for web files. Falls back to LSP formatter for any unconfigured filetype. |
| `mfussenegger/nvim-lint` | Runs `mypy` on Python files on save and read. Separate from ruff to allow strict mypy type checking alongside fast ruff linting.                      |

### Treesitter (`treesitter.lua`)

| Plugin                            | Purpose                                                                                          |
| --------------------------------- | ------------------------------------------------------------------------------------------------ |
| `nvim-treesitter/nvim-treesitter` | Syntax highlighting and indentation. Parsers installed for all languages matching the LSP setup. |
| `windwp/nvim-ts-autotag`          | Auto-closes and auto-renames HTML/JSX/TSX tags using treesitter.                                 |

### Editor (`editor.lua`)

| Plugin                                      | Purpose                                                                                                                                                  |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `windwp/nvim-autopairs`                     | Auto-closes brackets and quotes in insert mode.                                                                                                          |
| `tpope/vim-sleuth`                          | Automatically detects and sets `tabstop`/`shiftwidth` from the file being edited. Useful when working across projects with different indent conventions. |
| `stevearc/dressing.nvim`                    | Replaces `vim.ui.select` and `vim.ui.input` with floating pickers. LSP rename and code action menus use fzf-lua automatically.                           |
| `RRethy/vim-illuminate`                     | Highlights all other occurrences of the word/symbol under the cursor using LSP or treesitter. 100ms delay to avoid flashing on fast cursor movement.     |
| `MeanderingProgrammer/render-markdown.nvim` | Renders markdown formatting inline in normal mode. Active for markdown and vimwiki filetypes.                                                            |
| `kevinhwang91/nvim-ufo`                     | LSP/treesitter-based code folding. Replaces Neovim's unreliable built-in folding. All folds start open (`foldlevel = 99`).                               |

### Navigation (`navigation.lua`)

| Plugin                           | Purpose                                                                                                                                |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `ibhagwan/fzf-lua`               | Fuzzy finder for files, grep, buffers, recent files, git commits, and LSP symbols.                                                     |
| `folke/which-key.nvim`           | Displays available keybindings in a popup after pressing `<leader>`. Groups configured for `f`, `g`, `t`, `p`, `y` prefixes.           |
| `stevearc/oil.nvim`              | File explorer as an editable buffer. Shows icons, file sizes, and hidden files. Git status and LSP diagnostics shown via dependencies. |
| `christoomey/vim-tmux-navigator` | Seamless pane navigation between Neovim splits and tmux panes using `<C-hjkl>`.                                                        |
| `mbbill/undotree`                | Visual undo history tree.                                                                                                              |

### Git (`git.lua`)

| Plugin                     | Purpose                                                                                                     |
| -------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `lewis6991/gitsigns.nvim`  | Git hunk indicators in the sign column. Shows added, changed, and removed lines.                            |
| `folke/todo-comments.nvim` | Highlights and indexes `TODO`, `FIXME`, `HACK`, `NOTE`, and similar comments. Integrated with trouble.nvim. |
| `folke/trouble.nvim`       | Diagnostics, LSP references, and TODO list in a structured panel.                                           |

### TypeScript (`typescript.lua`)

| Plugin                              | Purpose                                                                                                                                                         |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `pmizio/typescript-tools.nvim`      | Replaces `ts_ls`. Communicates with tsserver directly for faster performance. Exposes organize imports, add missing imports, and remove unused as code actions. |
| `dmmulroy/ts-error-translator.nvim` | Translates cryptic TypeScript error messages into plain English. Zero config.                                                                                   |

### Python (`python.lua`)

| Plugin                             | Purpose                                                                                                                                                                          |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `linux-cultist/venv-selector.nvim` | Detects and activates Python virtual environments (uv, Poetry, Pipenv, Conda). Notifies on activation. Required for basedpyright and ruff to resolve project packages correctly. |

---

## Keymaps

`<leader>` is set to `<Space>`.

### General

| Key         | Mode            | Action                                                                |
| ----------- | --------------- | --------------------------------------------------------------------- |
| `<leader>p` | visual          | Paste without overwriting the yank register                           |
| `<leader>y` | normal / visual | Copy to system clipboard                                              |
| `<leader>Y` | normal          | Copy line to system clipboard                                         |
| `<leader>s` | normal          | Replace word under cursor across the file (opens substitution prompt) |
| `<leader>x` | normal          | Make current file executable (`chmod +x`)                             |
| `<leader>u` | normal          | Toggle undo tree                                                      |

### Navigation

| Key          | Mode   | Action                         |
| ------------ | ------ | ------------------------------ |
| `<C-h>`      | normal | Move to left pane / tmux pane  |
| `<C-j>`      | normal | Move to lower pane / tmux pane |
| `<C-k>`      | normal | Move to upper pane / tmux pane |
| `<C-l>`      | normal | Move to right pane / tmux pane |
| `<leader>pv` | normal | Open Oil file explorer         |

### Find (fzf-lua)

| Key          | Mode   | Action               |
| ------------ | ------ | -------------------- |
| `<leader>ff` | normal | Find files           |
| `<leader>fg` | normal | Live grep            |
| `<leader>fb` | normal | Open buffers         |
| `<leader>fr` | normal | Recent files         |
| `<leader>fc` | normal | Git commits          |
| `<leader>fs` | normal | LSP document symbols |

### LSP

The following are set automatically by Neovim 0.10+ on `LspAttach`:

| Key     | Mode   | Action                |
| ------- | ------ | --------------------- |
| `K`     | normal | Hover documentation   |
| `gd`    | normal | Go to definition      |
| `gD`    | normal | Go to declaration     |
| `grr`   | normal | References            |
| `gri`   | normal | Go to implementation  |
| `grt`   | normal | Go to type definition |
| `grn`   | normal | Rename symbol         |
| `gra`   | normal | Code action           |
| `<C-s>` | insert | Signature help        |

Custom LSP keymaps:

| Key          | Mode   | Action                |
| ------------ | ------ | --------------------- |
| `<leader>ih` | normal | Toggle inlay hints    |
| `<leader>gf` | normal | Format current buffer |

### Diagnostics / Trouble

| Key          | Mode   | Action                   |
| ------------ | ------ | ------------------------ |
| `<leader>td` | normal | Project-wide diagnostics |
| `<leader>tb` | normal | Buffer diagnostics       |
| `<leader>ts` | normal | Symbol outline           |
| `<leader>tr` | normal | LSP references           |
| `<leader>tt` | normal | TODO / FIXME list        |

### Folding (nvim-ufo)

| Key         | Mode   | Action                                                        |
| ----------- | ------ | ------------------------------------------------------------- |
| `zR`        | normal | Open all folds                                                |
| `zM`        | normal | Close all folds                                               |
| `zK`        | normal | Peek fold contents (falls back to LSP hover if not on a fold) |
| `za`        | normal | Toggle fold under cursor (built-in)                           |
| `zo` / `zc` | normal | Open / close fold (built-in)                                  |
| `zj` / `zk` | normal | Jump to next / previous fold (built-in)                       |

### Completion (blink.cmp)

| Key       | Mode   | Action                       |
| --------- | ------ | ---------------------------- |
| `<Tab>`   | insert | Next snippet placeholder     |
| `<S-Tab>` | insert | Previous snippet placeholder |

See [blink.cmp default preset](https://cmp.saghen.dev/configuration/keymap.html#default) for the full completion keymap.

### Python

| Key          | Mode   | Action                            |
| ------------ | ------ | --------------------------------- |
| `<leader>vs` | normal | Select Python virtual environment |

---

## Notes

- `hls` (Haskell Language Server) must be installed via GHCup — it is not available through Mason. It is still enabled via `vim.lsp.enable("hls")` and will work as long as it is on `$PATH`.
- `mypy` must be installed in the active virtual environment for nvim-lint to find it. Activate the correct venv with `<leader>vs` before opening Python files.
- Treesitter parsers install automatically on first launch via `ensure_installed`. This may take a moment.
- All LSP servers in `ensure_installed` are auto-installed by Mason on first launch except `hls`.
