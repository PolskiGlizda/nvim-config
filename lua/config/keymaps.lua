--- leader key
vim.g.mapleader = " "

--- clipboard
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without overwriting register" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })

--- replace word under cursor project-wide
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor", silent = true }
)

--- make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make file executable", silent = true })

--- diagnostic navigation
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]e", function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next error" })
vim.keymap.set("n", "[e", function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev error" })
vim.keymap.set("n", "]w", function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.WARN }) end, { desc = "Next warning" })
vim.keymap.set("n", "[w", function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.WARN }) end, { desc = "Prev warning" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Open diagnostic float" })

