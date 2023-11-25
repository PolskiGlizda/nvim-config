# My NeoVIM config

Simple NeoVIM config written in lua for general-purpose use.

## Plugins

Plugins are handled by Packer
| Plugin | Description |
| ------ | ----------- |
| [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder for files in projects |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Better highlighting |
| [nvim-treesitter/playground](https://github.com/nvim-treesitter/playground) | Tree-sitter info |
| [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon) | Fast navigation between files |
| [mbbill/undotree](https://github.com/mbbill/undotree) | Undo history |
| [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive) | Handling Git |
| [VonHeikemen/lsp-zero.nvim](https://github.com/VonHeikemen/lsp-zero.nvim) | LSP configuration |
| [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) | LSP manager |
| [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua) | GitHub Copilot integration |
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | Key bindings helper |
| [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim) | Comment handler |
| [NvChad/nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua) | Colour highlights |
| [uga-rosa/ccc.nvim](https://github.com/uga-rosa/ccc.nvim) | Colour picker |
| [altermo/ultimate-autopair.nvim](https://github.com/altermo/ultimate-autopair.nvim) | Auto pairing(e.g auto closing brackets) |
| [ziontee113/icon-picker.nvim](https://github.com/ziontee113/icon-picker.nvim) | Icon picker from Alt-Font/Nerd-Fonts |
| [alec-gibson/nvim-tetris](https://github.com/alec-gibson/nvim-tetris) | Tetris because why not :grinning: |

## Colour scheme

[rose-pine/neovim](https://github.com/rose-pine/neovim) with transparent background

## Custom key binds

\<leader\> = " "

### General

#### Normal mode

| Key Bind | Description |
| -------- | ----------- |
| \<leader\>pv | Native NeoVIM file manager(Ex) |
| \<leader\>y | Yank to system clipboard |
| \<leader\>Y | Yank whole line to system clipboard |
| \<leader\>s | Replace a word  globaly |
| \<leader\>x | Make current file executable(Unix-like OS exlusive) |

#### Visual mode

| Key Bind | Description |
| -------- | ----------- |
| \<leader\>p | Paste but keep current buffor |
| \<leader\>y | Yank to system clipboard |

#### Insert mode

### Plugin

#### Telescope

| Key Bind | Description |
| -------- | ----------- |
| \<leader\>pf | File finder |
| \<C-p\> | Git file finder |
| \<leader\>ps | Grep search |

#### Harpoon

| Key Bind | Description |
| -------- | ----------- |
| \<leader\>a | Add file to the list |
| \<C-e\> | Show list |
| \<C-h\> | Go to file 1 |
| \<C-t\> | Go to file 2 |
| \<C-n\> | Go to file 3 |
| \<C-s\> | Go to file 4 |

#### UndoTree

| Key Bind | Description |
| -------- | ----------- |
| \<leader\>u | Open UndoTree |

#### Fugitive

| Key Bind | Description |
| -------- | ----------- |
| \<leader\>gs | Open git |

#### LSP-zero

##### Snippets

| Key Bind | Description |
| -------- | ----------- |
| \<C-p\> | Previous item |
| \<C-n\> | Next item |
| \<C-y\> | Confirm |
| \<C-Space\> | Complete |

##### Normal mode

| Key Bind | Description |
| -------- | ----------- |
| gd | Go to definition |
| K | Manual of hovered |
| \<leader\>vws | Workspace symbol |
| \<leader\>vd | Open float |
| [d | Go to next |
| ]d | Go to previous |
| \<leader\>vca | Code action |
| \<leader\>vrr | References |
| \<leader\>vrn | Rename |

##### Input mode

| Key Bind | Description |
| -------- | ----------- |
| \<C-h\> | Signature help |

#### Comment

##### Normal mode

| Key Bind | Description |
| -------- | ----------- |
| gcc | Toggle comment current line |
| gbc | Toggle comment current block |
| [count]gcc | Toggle comment given lines |
| [count]gbc | Toggle comment given blocks |

##### Visual mode

| Key Bind | Description |
| -------- | ----------- |
| gc | Toggle comment region linewise |
| gb | Toggle comment region blockwise |

## Custom options

 - Relative line numbers
 - Tab size 4
 - Smart indent
 - No swap file
 - No backup
 - Undodir in `$HOME/.vim/undodir`
 - Undofile on
 - No search highlight
 - Incremental search on
 - 24 bit colours
 - Scrolloff 8
