# My NeoVIM config

Simple NeoVIM config written in lua for general-purpose use.

## Instalation
### Linux/MacOS
#### Main config
``` bash
# make a backup of your current config
    mv ~/.config/nvim{,.bak}
    mv ~/.local/share/nvim{,.bak}
    mv ~/.local/state/nvim{,.bak}
    mv ~/.cache/nvim{,.bak}
# install packer
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# install this config
    git clone https://github.com/PolskiGlizda/nvim-config.git ~/.config/nvim
# launch NeoVIM
    nvim
# inside nvim run :PackerSync
```
#### Side config
``` bash
# install packer
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# install this config
    git clone https://github.com/PolskiGlizda/nvim-config.git ~/.config/PolskiGlizda/nvim-config
# install plugins
    NVIM_APPNAME=PolskiGlizda/nvim-config/ nvim --headless +"PackerSync" +qa
# run this config
    NVIM_APPNAME=PolskiGlizda/nvim-config/ nvim
```
### Windows
NOTE: if you're using Windows 10, you need developer mode enabled in order to use local plugins (creating symbolic links requires admin privileges on Windows)
``` PowerShell
# make a backup of current config
    Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
    Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
# install packer
    git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
# install this config
    git clone https://github.com/PolskiGlizda/nvim-config.git $env:LOCALAPPDATA\nvim
# start nvim
    nvim
# inside nvim run :PackerSync
```

## Adding plugins
### Linux/MacOS
Adding plugins is as simple as editing few lines. First you need to add plugin to packer:

``` bash
    nvim ~/.config/nvim/lua/glizda/packer.lua
```
Here you'll see all the plugins added to packer. To add another one simply go to the end of file and create new line before `end)` and write
``` lua
    use("mainteiner-name/plugin-name")
```
Now save file and run
``` vim
    :so
    :PackerSync
```
The plugin is now installed but you need one more thing for it to work
```bash
# create a file
    touch ~/.config/nvim/after/plugin/plugin-name.lua
# edit it
    nvim ~/.config/nvim/after/plugin/plugin-name.lua
```
Here will be your configuration for this plugin, I'll show the most basic way to use it. For more information check out documentation on the plugin. Now create an object of this plugin and start it:

``` lua
    local plugin_name = require("plugin-name")
    plugin_name.setup({
        -- here place your configuration
        })
```
### Windows
Adding plugins is as simple as editing few lines. First you need to add plugin to packer:

``` PowerShell
    nvim $env:LOCALAPPDATA\nvim\lua\glizda\packer.lua
```

Here you'll see all the plugins added to packer. To add another one simply go to the end of file and create new line before `end)` and write
``` lua
    use("mainteiner-name/plugin-name")
```
Now save file and run
``` vim
    :so
    :PackerSync
```
The plugin is now installed but you need one more thing for it to work
``` PowerShell
# create a file
    New-Item $env:LOCALAPPDATA\nvim\after\plugin\plugin-name.lua
# edit it
    nvim $env:LOCALAPPDATA\nvim\after\plugin\plugin-name.lua
```
Here will be your configuration for this plugin, I'll show the most basic way to use it. For more information check out documentation on the plugin. Now create an object of this plugin and start it:

``` lua
    local plugin_name = require("plugin-name")
    plugin_name.setup({
        -- here place your configuration
        })
```

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
| [github/copilot.vim](https://github.com/github/copilot.vim) | GitHub Copilot integration |
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

## Editing config
This config is written using atomic design methodology, witch means that it's very easy to find options you want to change.

### Editing key binding
If you'd like to add, change or remove general bindings just edit `nvim/lua/glizda/remap.lua`(`vim.keymap.set("mode", "bind", "action")`). Here also you can change \<leader\> key (`vim.g.mapleader = "new key"`). And if you'd like to change bindings for plugins go to `nvim/after/` folder and edit file responsible for particular plugin.

### Editing options
If you'd like to add, change or remove options you can edit `nvim/lua/glizda/set.lua`, here you can find general options for neovim(`vim.opt.option = value`).

## For more information
If you want to know more about configuring NeoVIM I highly recommend [NeoVIM docs](https://neovim.io/doc/), [ArchWiki](https://wiki.archlinux.org/title/Neovim) and [VIM help](https://vimhelp.org/)
