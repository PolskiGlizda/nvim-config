--- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

--- indentation: 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

--- persistent undo, no swap or backup files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

--- search
vim.opt.hlsearch = false
vim.opt.incsearch = true

--- colours
vim.opt.termguicolors = true

--- ui
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.showmode = false
vim.opt.smoothscroll = false
vim.opt.timeoutlen = 1000
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.cmdheight = 1
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"

--- reduce latency for cursorhold events (affects gitsigns, hover)
vim.opt.updatetime = 250

--- fold column glyphs (nerd font required)
vim.opt.fillchars = {
	foldopen = "▾",
	foldclose = "▸",
	fold = " ",
	foldsep = " ",
	eob = " ",
}

--- folding — high foldlevel keeps all folds open by default (nvim-ufo)
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
