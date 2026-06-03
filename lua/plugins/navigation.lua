---@type LazySpec
return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-mini/mini.icons" },
		opts = {
			winopts = {
				border = "rounded",
				height = 0.85,
				width = 0.80,
				preview = { border = "rounded" },
			},
			grep = {
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
			},
		},
		config = function(_, opts)
			local fzf = require("fzf-lua")
			fzf.setup(opts)
			fzf.register_ui_select()
			vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Files" })
			vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Grep" })
			vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
			vim.keymap.set("n", "<leader>fc", fzf.git_commits, { desc = "Git commits" })
			vim.keymap.set("n", "gO", fzf.lsp_document_symbols, { desc = "Document symbols" })
			vim.keymap.set("n", "gra", fzf.lsp_code_actions, { desc = "Code actions" })
			vim.keymap.set("n", "<leader>fS", fzf.lsp_live_workspace_symbols, { desc = "Workspace symbols" })
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			spec = {
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>t", group = "trouble" },
				{ "<leader>p", group = "project" },
				{ "<leader>y", group = "yank" },
				{ "<leader>c", group = "code" },
			},
		},
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-mini/mini.icons", "benomahony/oil-git.nvim", "JezerM/oil-lsp-diagnostics.nvim" },
		opts = {
			columns = {
				"icon",
				"size",
			},
			default_file_explorer = true,
			view_options = {
				show_hidden = true,
			},
		},
		keys = {
			{ "<leader>pv", "<cmd>Oil<CR>", desc = "Open Oil" },
		},
		lazy = false,
	},
	{
		"christoomey/vim-tmux-navigator",
		config = function()
			vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Navigate left" })
			vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Navigate down" })
			vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Navigate up" })
			vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Navigate right" })
		end,
	},
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
}
