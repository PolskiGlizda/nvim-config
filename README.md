# Neovim Configuration

<a href="https://dotfyle.com/PolskiGlizda/nvim-config"><img src="https://dotfyle.com/PolskiGlizda/nvim-config/badges/plugins?style=for-the-badge" /></a>
<a href="https://dotfyle.com/PolskiGlizda/nvim-config"><img src="https://dotfyle.com/PolskiGlizda/nvim-config/badges/leaderkey?style=for-the-badge" /></a>
<a href="https://dotfyle.com/PolskiGlizda/nvim-config"><img src="https://dotfyle.com/PolskiGlizda/nvim-config/badges/plugin-manager?style=for-the-badge" /></a>

A personal Neovim configuration targeting Neovim 0.12+ built around a modern LSP-first workflow with support for web development, systems programming, and scripting.

---

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Structure](#structure)
- [Design Decisions](#design-decisions)
- [Plugins](#plugins)
  - [Theme & UI](#theme--ui-colorschemelua-uilua)
  - [LSP](#lsp-lsplua)
  - [Completion](#completion-completionlua)
  - [Formatting & Linting](#formatting--linting-formattinglua)
  - [Treesitter](#treesitter-treesitterlua)
  - [Editor](#editor-editorlua)
  - [Navigation](#navigation-navigationlua)
  - [Git](#git-gitlua)
  - [TypeScript](#typescript-typescriptlua)
  - [Python](#python-pythonlua)
- [Snippets](#snippets)
- [Keymaps](#keymaps)

---

## Requirements

- Neovim 0.12+ (uses `vim.lsp.document_color`, `vim.diagnostic.jump`)
- [lazy.nvim](https://github.com/folke/lazy.nvim) (auto-installed on first launch)
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- `git` for plugin management
- `fzf` for fuzzy finding
- A terminal with true colour support

Optional but expected:

- [WezTerm](https://wezfurlong.org/wezterm/) with the `smart-splits.nvim` plugin applied to its config for seamless split navigation
- `stylua` for Lua formatting
- `prettier` for web formatting
- `ruff` for Python formatting
- `mypy` for Python type checking (installed per-project via uv)
- GHCup for Haskell (`hls` is not installable via Mason)

---

## Installation

> Back up any existing config first:
>
> ```sh
> mv ~/.config/nvim ~/.config/nvim.bak
> ```

**1. Clone the repository**

```sh
git clone https://github.com/PolskiGlizda/nvim-config ~/.config/nvim
```

**2. Launch Neovim**

```sh
nvim
```

lazy.nvim bootstraps itself on first launch, then installs all plugins automatically. Wait for it to finish.

**3. Install LSP servers & Tools**

Mason installs all configured servers and tools automatically on first launch via `mason-tool-installer`. You can also open `:Mason` to monitor progress or install tools manually.

> `hls` (Haskell Language Server) is not available through Mason. Install it via GHCup:
>
> ```sh
> ghcup install hls
> ```

**4. Install Treesitter parsers**

Parsers install automatically via `ensure_installed` on first launch. To install or update manually:

```
:TSUpdate
```

**5. Python type checking**

`mypy` must be installed inside each project's virtual environment. Activate the correct venv with `<leader>vs` before opening Python files, then install mypy in it:

```sh
uv add --dev mypy
```

---

## Structure

```
~/.config/nvim/
├── init.lua                 entry point
├── .luarc.json              lua_ls config scoped to this directory
├── lazy-lock.json           plugin version lockfile
├── snippets/                custom snippets (VSCode format, per filetype)
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

### tokyonight over onedark

tokyonight ships explicit integration palettes for virtually every plugin in this config — blink.cmp, noice, trouble, gitsigns, lualine, which-key, lazy.nvim, and more. With onedark each plugin falls back to its own default highlight groups, producing a disjointed look. With tokyonight, a single colorscheme call propagates a consistent palette across all UI surfaces automatically. The `night` style is used for high contrast.

### Native LSP over plugin wrappers

Uses Neovim's native `vim.lsp.enable()` and `vim.lsp.config()` API (0.11+) rather than configuring servers through `lspconfig.server.setup()`. This keeps server configuration declarative and consistent across all servers.

### blink.cmp over nvim-cmp

blink.cmp is faster, more actively maintained, and has a simpler configuration model. It also provides built-in Rust-based fuzzy matching (`fuzzy.implementation = "prefer_rust"`) and native signature help.

### conform.nvim over formatter.nvim

conform is async-first, supports format-on-save natively, and has a clean `lsp_format = "fallback"` option that automatically uses the LSP formatter for any filetype not explicitly configured.

### oil.nvim over nvim-tree / neo-tree

Oil treats the file explorer as an editable buffer. Directory contents can be manipulated with standard Vim motions — rename with `r`, delete with `dd`, move with cut/paste. This is more ergonomic than a sidebar tree.

### vtsls over ts_ls

Uses `vtsls` (via `nvim-vtsls`) for TypeScript support. It is faster than `ts_ls`, provides better refactoring tools, and supports advanced TypeScript features like "Go to Source Definition" and "Organize Imports" natively through LSP commands. `ts_ls` is explicitly disabled to prevent auto-attach conflicts in Neovim 0.13.

### Manual Treesitter activation

Instead of a standard `setup()` call, Treesitter is started manually via a `FileType` autocmd. This ensures that the Treesitter highlighter and indentation engine are only initialized when needed, providing a snappier experience when opening non-code files or very large buffers.

### grug-far.nvim for search & replace

Replaces standard substitution with a dedicated buffer-based search and replace tool. This provides a visual, editable interface for project-wide refactoring that is safer and more intuitive than the command line.

### Refactoring.nvim with previews

Leverages the latest `:Refactor` command interface to provide live previews of structural changes like function extraction or variable inlining.

### Bigfile optimization

Automatically detects and optimizes the editor environment for files larger than 2MiB by disabling Treesitter, LSP, and other heavy features.

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

### `showmode` disabled

`-- INSERT --` / `-- VISUAL --` is suppressed (`showmode = false`) because lualine already renders the current mode in the statusline. Showing it twice is noise. `splitright` and `splitbelow` are enabled so vertical and horizontal splits open in the direction that matches reading order. `cursorline` is enabled for easier line tracking.

### Diagnostic virtual lines, not virtual text

`virtual_lines = true` renders diagnostics on a dedicated line below the code rather than inline. This avoids cluttering the code itself and works better with longer error messages. `virtual_text` is explicitly disabled to prevent duplication.

### Joke cache for btw.nvim

The startup joke is fetched asynchronously and cached to disk. On each launch the previous joke is shown instantly from cache while a new one is fetched in the background for the next session. This avoids blocking startup on a network request.

---

## Plugins

### Theme & UI (`colorscheme.lua`, `ui.lua`)

| Plugin                                                                                                      | Purpose                                                                                                                                                                                                       |
| ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`folke/tokyonight.nvim`](https://github.com/folke/tokyonight.nvim)                                         | Colorscheme (night style). Ships integration palettes for blink.cmp, noice, trouble, gitsigns, lualine, and other plugins for a cohesive look across all UI surfaces.                                        |
| [`nvim-mini/mini.icons`](https://github.com/echasnovski/mini.icons)                                         | Icon provider used by oil, fzf-lua, lualine, trouble, and render-markdown.                                                                                                                                    |
| [`folke/noice.nvim`](https://github.com/folke/noice.nvim)                                                   | Routes LSP progress, notifications, and `vim.ui.input` prompts (rename, etc.) through a styled floating UI. Cmdline kept at the bottom (`view = "cmdline"`).                                                  |
| [`nvim-lualine/lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim)                                 | Statusline showing mode, branch, diagnostics, filename, encoding, filetype, progress, clock, and cursor position. Uses the tokyonight theme for palette consistency.                                          |
| [`utilyre/barbecue.nvim`](https://github.com/utilyre/barbecue.nvim)                                         | LSP breadcrumb trail in the winbar. Shows the current symbol path (`Module > Class > method`) updated on cursor move. Powered by nvim-navic attached on `LspAttach`.                                         |
| [`SmiteshP/nvim-navic`](https://github.com/SmiteshP/nvim-navic)                                             | LSP symbol provider for barbecue. Attaches to each LSP client that supports `documentSymbolProvider`.                                                                                                        |
| [`nvimdev/indentmini.nvim`](https://github.com/nvimdev/indentmini.nvim)                                     | Lightweight indent guides.                                                                                                                                                                                    |
| [`NvChad/nvim-colorizer.lua`](https://github.com/NvChad/nvim-colorizer.lua)                                 | Inline colour previews for hex codes and CSS colour names.                                                                                                                                                    |
| [`MeanderingProgrammer/render-markdown.nvim`](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Renders markdown formatting inline in normal mode. Active for markdown and vimwiki filetypes.                                                                                                                 |
| [`letieu/btw.nvim`](https://github.com/letieu/btw.nvim)                                                     | Startup message. Displays a cached programming joke fetched from jokeapi.dev.                                                                                                                                 |

### LSP (`lsp.lua`)

| Plugin                                                                                                      | Purpose                                                                                                              |
| ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| [`neovim/nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig)                                         | Provides default server configurations (root detection, filetypes, cmd). Servers are enabled via `vim.lsp.enable()`. |
| [`mason-org/mason.nvim`](https://github.com/mason-org/mason.nvim)                                           | LSP server installer.                                                                                                |
| [`WhoIsSethPueblo/mason-tool-installer.nvim`](https://github.com/WhoIsSethPueblo/mason-tool-installer.nvim) | Automates installation of LSPs, formatters, and linters.                                                             |
| [`mason-org/mason-lspconfig.nvim`](https://github.com/mason-org/mason-lspconfig.nvim)                       | Bridges Mason and lspconfig. Server installation is handled exclusively by `mason-tool-installer`.                   |
| [`folke/lazydev.nvim`](https://github.com/folke/lazydev.nvim)                                               | Neovim Lua API type definitions for `lua_ls`. Scoped to Lua files only (`ft = "lua"`).                               |
| [`b0o/schemastore.nvim`](https://github.com/b0o/schemastore.nvim)                                           | Provides the SchemaStore catalog to `jsonls` and `yamlls`.                                                           |

**Enabled servers:**

| Server                  | Language                                     |
| ----------------------- | -------------------------------------------- |
| `hls`                   | Haskell (installed via GHCup, not Mason)     |
| `rust-analyzer`         | Rust                                         |
| `gopls`                 | Go                                           |
| `clangd`                | C / C++                                      |
| `zls`                   | Zig                                          |
| `asm_lsp`               | Assembly                                     |
| `vtsls`                 | TypeScript / JavaScript (see typescript.lua) |
| `tailwindcss`           | Tailwind CSS                                 |
| `emmet_language_server` | HTML / JSX Emmet                             |
| `cssls`                 | CSS                                          |
| `html`                  | HTML                                         |
| `htmx`                  | HTMX (HTML only)                             |
| `bashls`                | Bash                                         |
| `lua_ls`                | Lua                                          |
| `vimls`                 | Vimscript (used when maintaining `.vimrc`)   |
| `basedpyright`          | Python (navigation only, type checking off)  |
| `ruff`                  | Python (linting via LSP)                     |
| `jsonls`                | JSON                                         |
| `yamlls`                | YAML                                         |
| `terraform-ls`          | Terraform                                    |

### Completion (`completion.lua`)

| Plugin                                                                            | Purpose                                                                                                                                         |
| --------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| [`saghen/blink.cmp`](https://github.com/saghen/blink.cmp)                         | Completion engine. Sources: LSP (score 1000), lazydev (score 100), path, snippets, buffer. Rust fuzzy matching enabled. Signature help enabled. |
| [`rafamadriz/friendly-snippets`](https://github.com/rafamadriz/friendly-snippets) | Snippet collection loaded by blink.cmp.                                                                                                         |

### Formatting & Linting (`formatting.lua`)

| Plugin                                                                | Purpose                                                                                                                                               |
| --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`stevearc/conform.nvim`](https://github.com/stevearc/conform.nvim)   | Format on save. Uses `stylua` for Lua, `ruff_format` for Python, `prettier` for web files. Falls back to LSP formatter for any unconfigured filetype. |
| [`mfussenegger/nvim-lint`](https://github.com/mfussenegger/nvim-lint) | Runs `mypy` on Python files on save and read. Separate from ruff to allow strict mypy type checking alongside fast ruff linting.                      |

### Treesitter (`treesitter.lua`)

| Plugin                                                                                                          | Purpose                                                                                          |
| --------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| [`nvim-treesitter/nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)                         | Syntax highlighting and indentation. Parsers installed for all languages matching the LSP setup. |
| [`nvim-treesitter/nvim-treesitter-textobjects`](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Provides structural selection and movement (functions, classes, etc.) using treesitter queries.  |
| [`windwp/nvim-ts-autotag`](https://github.com/windwp/nvim-ts-autotag)                                           | Auto-closes and auto-renames HTML/JSX/TSX tags using treesitter.                                 |

### Editor (`editor.lua`)

| Plugin                                                                              | Purpose                                                                                                                                                                                   |
| ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`windwp/nvim-autopairs`](https://github.com/windwp/nvim-autopairs)                 | Auto-closes brackets and quotes in insert mode.                                                                                                                                           |
| [`kylechui/nvim-surround`](https://github.com/kylechui/nvim-surround)               | Add, change, and delete surrounding delimiters (brackets, quotes, tags). `ys{motion}{char}` to add, `cs{old}{new}` to change, `ds{char}` to delete.                                       |
| [`monaqa/dial.nvim`](https://github.com/monaqa/dial.nvim)                           | Extended increment/decrement. `<C-a>`/`<C-x>` cycles `true`↔`false`, `&&`↔`\|\|`, `const`↔`let`, dates, and semver numbers in addition to integers.                                       |
| [`ThePrimeagen/refactoring.nvim`](https://github.com/ThePrimeagen/refactoring.nvim) | Structural refactoring tool powered by Treesitter and LSP. Supports extraction, inlining, and block refactoring.                                                                          |
| [`LunarVim/bigfile.nvim`](https://github.com/LunarVim/bigfile.nvim)                 | Performance optimizer that automatically disables heavy features for files exceeding a specific size.                                                                                     |
| [`MagicDuck/grug-far.nvim`](https://github.com/MagicDuck/grug-far.nvim)             | Project-wide search and replace in a dedicated buffer. Fast, visual, and highly configurable.                                                                                             |
| [`chrisgrieser/nvim-spider`](https://github.com/chrisgrieser/nvim-spider)           | Subword motions for `w`, `e`, `b`, and `ge`. Works with camelCase and snake_case out of the box.                                                                                          |
| [`tpope/vim-sleuth`](https://github.com/tpope/vim-sleuth)                           | Automatically detects and sets `tabstop`/`shiftwidth` from the file being edited. Useful when working across projects with different indent conventions.                                  |
| [`andymass/vim-matchup`](https://github.com/andymass/vim-matchup)                   | Extends `%` to match language keywords (`if`/`end`, `function`/`end`, HTML tags) using treesitter. Offscreen matches shown in a popup.                                                    |
| [`folke/ts-comments.nvim`](https://github.com/folke/ts-comments.nvim)               | Fixes comment strings in embedded languages. `gc` inside a `<script>` block uses `//`, inside CSS uses `/* */`, inside TSX expressions uses the correct style.                            |
| [`danymat/neogen`](https://github.com/danymat/neogen)                               | Docstring/annotation generator. `<leader>ng` inserts a template for the function or class under the cursor. Python: Google style. TypeScript: JSDoc. Lua: LDoc. Go: godoc. Rust: rustdoc. |
| [`kevinhwang91/nvim-ufo`](https://github.com/kevinhwang91/nvim-ufo)                 | LSP/treesitter-based code folding. Replaces Neovim's unreliable built-in folding. All folds start open (`foldlevel = 99`).                                                                |

### Navigation (`navigation.lua`)

| Plugin                                                                                | Purpose                                                                                                                                |
| ------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| [`ibhagwan/fzf-lua`](https://github.com/ibhagwan/fzf-lua)                             | Fuzzy finder for files, grep, buffers, recent files, git commits, and LSP symbols. Registered as the `vim.ui.select` provider. Configured with rounded borders and 85×80% window sizing. |
| [`folke/which-key.nvim`](https://github.com/folke/which-key.nvim)                     | Displays available keybindings in a popup after pressing `<leader>`. Groups: `f` find, `g` git, `t` trouble, `p` project (Oil `pv`, Yazi `py`), `y` yank, `c` code. |
| [`stevearc/oil.nvim`](https://github.com/stevearc/oil.nvim)                           | File explorer as an editable buffer. Shows icons, file sizes, and hidden files. Git status and LSP diagnostics shown via dependencies. Default file explorer. |
| [`mikavilpas/yazi.nvim`](https://github.com/mikavilpas/yazi.nvim)                     | Yazi file manager in a floating terminal. Complements Oil: use Yazi for rich visual browsing and preview, Oil for bulk rename/move via Vim motions. |
| [`folke/snacks.nvim`](https://github.com/folke/snacks.nvim)                           | Utility plugin collection. Used by yazi.nvim for its floating terminal window. Only the `terminal` module is enabled. |
| [`mrjones2014/smart-splits.nvim`](https://github.com/mrjones2014/smart-splits.nvim)   | Seamless split navigation and resizing across Neovim splits and WezTerm panes. `<C-hjkl>` / `<A-hjkl>` to navigate, `<A-HJKL>` to resize. |
| [`mbbill/undotree`](https://github.com/mbbill/undotree)                               | Visual undo history tree.                                                                                                              |

### Git (`git.lua`)

| Plugin                                                                    | Purpose                                                                                                     |
| ------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| [`lewis6991/gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim)   | Git hunk indicators in the sign column. Shows added, changed, and removed lines.                            |
| [`folke/todo-comments.nvim`](https://github.com/folke/todo-comments.nvim) | Highlights and indexes `TODO`, `FIXME`, `HACK`, `NOTE`, and similar comments. Integrated with trouble.nvim. |
| [`folke/trouble.nvim`](https://github.com/folke/trouble.nvim)             | Diagnostics, LSP references, and TODO list in a structured panel.                                           |

### TypeScript (`typescript.lua`)

| Key   | Action                  |
| ----- | ----------------------- |
| `grO` | Organize Imports        |
| `grU` | Remove Unused Imports   |
| `grM` | Add Missing Imports     |
| `grF` | Fix All Diagnostics     |
| `grR` | Rename File             |
| `gs`  | Go to Source Definition |

| Plugin                                                                                      | Purpose                                                                                                                                                          |
| ------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`yioneko/nvim-vtsls`](https://github.com/yioneko/nvim-vtsls)                               | Replaces `ts_ls`. Provides a high-performance wrapper around the TypeScript Language Server with support for organizing imports, fixing all, and renaming files. |
| [`dmmulroy/ts-error-translator.nvim`](https://github.com/dmmulroy/ts-error-translator.nvim) | Translates cryptic TypeScript error messages into plain English. Zero config.                                                                                    |

### Python (`python.lua`)

| Plugin                                                                                    | Purpose                                                                                                                                                                          |
| ----------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`linux-cultist/venv-selector.nvim`](https://github.com/linux-cultist/venv-selector.nvim) | Detects and activates Python virtual environments (uv, Poetry, Pipenv, Conda). Notifies on activation. Required for basedpyright and ruff to resolve project packages correctly. |

---

## Snippets

Custom snippets live in `snippets/` and are loaded by blink.cmp alongside `friendly-snippets`. Files follow the VSCode JSON format and are matched by filetype name.

| File                   | Highlights                                                                                                          |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `python.json`          | Main guard, function with Google docstring, dataclass, type alias, list/dict comprehension, uv inline script header |
| `typescript.json`      | Arrow function, async function, interface, type alias, enum, try/catch                                              |
| `typescriptreact.json` | Functional component with typed props, useState, useEffect, useCallback, useMemo                                    |
| `javascript.json`      | Arrow function, async function, try/catch                                                                           |
| `javascriptreact.json` | Functional component, useState, useEffect                                                                           |
| `lua.json`             | Local function, module pattern, require, LDoc comment, keymap, autocmd                                              |
| `go.json`              | Main, function, method, struct, interface, error check, goroutine, channel, test                                    |
| `rust.json`            | Function, struct, enum, impl, impl trait, match, test module, derive                                                |
| `c.json`               | Main, include guard, typedef struct, for loop, printf                                                               |
| `cpp.json`             | Main, class, include guard, namespace, template function, cout                                                      |
| `bash.json`            | Shebang with safe defaults, function, if/else, for, while, case, command existence check                            |
| `haskell.json`         | Module, main, function with type signature, data type, newtype, typeclass instance, import                          |
| `zig.json`             | Main, function, struct, enum, GPA allocator setup, test, debug print                                                |
| `html.json`            | HTML5 boilerplate, stylesheet link, script tag                                                                      |
| `css.json`             | Media query, CSS variables, flexbox, grid, keyframes                                                                |

To add your own snippets, create or edit the relevant `snippets/<filetype>.json` file. Any VSCode snippet found online will work directly.

---

## Keymaps

`<leader>` is set to `<Space>`.

### General

| Key         | Mode            | Action                                            |
| ----------- | --------------- | ------------------------------------------------- |
| `<leader>p` | visual          | Paste without overwriting the yank register       |
| `<leader>y` | normal / visual | Copy to system clipboard                          |
| `<leader>Y` | normal          | Copy line to system clipboard                     |
| `<leader>s` | normal          | Open Grug-Far for project-wide search and replace |
| `<leader>x` | normal          | Make current file executable (`chmod +x`)         |
| `<leader>u` | normal          | Toggle undo tree                                  |

### Navigation

| Key          | Mode   | Action                                                                 |
| ------------ | ------ | ---------------------------------------------------------------------- |
| `<C-h>`      | normal | Move to left split (Neovim-internal only)                              |
| `<C-j>`      | normal | Move to lower split (Neovim-internal only)                             |
| `<C-k>`      | normal | Move to upper split (Neovim-internal only)                             |
| `<C-l>`      | normal | Move to right split (Neovim-internal only)                             |
| `<A-h>`      | normal | Move to left split or WezTerm pane (WezTerm forwards `ALT+h` here)    |
| `<A-j>`      | normal | Move to lower split or WezTerm pane                                    |
| `<A-k>`      | normal | Move to upper split or WezTerm pane                                    |
| `<A-l>`      | normal | Move to right split or WezTerm pane                                    |
| `<A-H>`      | normal | Resize split left (matches WezTerm `ALT+SHIFT+H`)                     |
| `<A-J>`      | normal | Resize split down (matches WezTerm `ALT+SHIFT+J`)                     |
| `<A-K>`      | normal | Resize split up (matches WezTerm `ALT+SHIFT+K`)                       |
| `<A-L>`      | normal | Resize split right (matches WezTerm `ALT+SHIFT+L`)                    |
| `<leader>pv` | normal | Open Oil file explorer                                                 |
| `<leader>-`  | normal | Open Yazi at the current file's directory                              |
| `<leader>py` | normal | Open Yazi at the current working directory                             |

### Find (fzf-lua)

| Key          | Mode   | Action               |
| ------------ | ------ | -------------------- |
| `<leader>ff` | normal | Find files           |
| `<leader>fg` | normal | Live grep            |
| `<leader>fb` | normal | Open buffers         |
| `<leader>fr` | normal | Recent files              |
| `<leader>fc` | normal | Git commits               |
| `<leader>fS` | normal | Workspace symbols (live)  |
| `gO`         | normal | LSP document symbols      |

### LSP

Set automatically by Neovim 0.11 on `LspAttach`:

| Key     | Mode   | Action              |
| ------- | ------ | ------------------- |
| `K`     | normal | Hover documentation |
| `grn`   | normal | Rename symbol       |
| `<C-s>` | insert | Signature help      |

Configured in this config (some override 0.11 defaults):

| Key           | Mode   | Action                                               |
| ------------- | ------ | ---------------------------------------------------- |
| `gd`          | normal | Go to definition                                     |
| `gD`          | normal | Go to declaration (clangd only)                      |
| `gt`          | normal | Go to type definition                                |
| `gri`         | normal | Go to implementation                                 |
| `grr`         | normal | References → Trouble panel                           |
| `gra`         | normal | Code actions → fzf-lua                               |
| `gO`          | normal | Document symbols → fzf-lua                           |
| `<leader>ih`  | normal | Toggle inlay hints                                   |
| `<leader>gf`  | normal | Format current buffer                                |
| `<leader>cl`  | normal | Run code lens under cursor (gopls, rust-analyzer, clangd) |
| `<leader>ci`  | normal | Incoming calls → fzf-lua                             |
| `<leader>co`  | normal | Outgoing calls → fzf-lua                             |
| `<leader>cs`  | normal | Type supertypes                                      |
| `<leader>cd`  | normal | Type subtypes                                        |

### Refactoring

| Key          | Mode   | Action                   |
| ------------ | ------ | ------------------------ |
| `<leader>re` | visual | Extract function         |
| `<leader>rf` | visual | Extract function to file |
| `<leader>rv` | visual | Extract variable         |
| `<leader>ri` | normal | Inline variable          |
| `<leader>rb` | normal | Extract block            |
| `<leader>rB` | normal | Extract block to file    |

### Diagnostics / Trouble

| Key          | Mode   | Action                   |
| ------------ | ------ | ------------------------ |
| `]d`         | normal | Next diagnostic          |
| `[d`         | normal | Previous diagnostic      |
| `]e`         | normal | Next error               |
| `[e`         | normal | Previous error           |
| `]w`         | normal | Next warning             |
| `[w`         | normal | Previous warning         |
| `gl`         | normal | Open diagnostic float    |
| `<leader>td` | normal | Project-wide diagnostics |
| `<leader>tb` | normal | Buffer diagnostics       |
| `<leader>ts` | normal | Symbol outline           |
| `<leader>tt` | normal | TODO / FIXME list        |

### Treesitter Textobjects

| Key  | Mode        | Action                          |
| ---- | ----------- | ------------------------------- |
| `af` | visual / op | Select around function          |
| `if` | visual / op | Select inside function          |
| `ac` | visual / op | Select around class             |
| `ic` | visual / op | Select inside class             |
| `]f` | normal      | Jump to next function start     |
| `[f` | normal      | Jump to previous function start |

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

### Annotations (neogen)

| Key          | Mode   | Action                                     |
| ------------ | ------ | ------------------------------------------ |
| `<leader>ng` | normal | Generate docstring for function/class/type |

### Python

| Key          | Mode   | Action                            |
| ------------ | ------ | --------------------------------- |
| `<leader>vs` | normal | Select Python virtual environment |

---

## Notes

- `hls` (Haskell Language Server) must be installed via GHCup — it is not available through Mason. It is still enabled via `vim.lsp.enable("hls")` and will work as long as it is on `$PATH`.
- `mypy` must be installed in the active virtual environment for nvim-lint to find it. Activate the correct venv with `<leader>vs` before opening Python files.
- Treesitter parsers install automatically on first launch via `ensure_installed`. This may take a moment.
- All LSP servers and tools in `ensure_installed` (including formatters and linters) are auto-installed by Mason on first launch via `mason-tool-installer`.
