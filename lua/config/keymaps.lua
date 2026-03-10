--- leader key
vim.g.mapleader = " "

--- clipboard
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without overwriting register" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })

--- replace word under cursor project-wide
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor", silent = true })

--- make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make file executable", silent = true })

--- pane navigation (overridden by vim-tmux-navigator)
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>", { desc = "Navigate up" })
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>", { desc = "Navigate down" })
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>", { desc = "Navigate left" })
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>", { desc = "Navigate right" })
