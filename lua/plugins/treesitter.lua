---@type LazySpec
return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
			local ensureInstalled = {
				"lua",
				"vim",
				"vimdoc",
				"typescript",
				"javascript",
				"tsx",
				"html",
				"css",
				"rust",
				"go",
				"c",
				"python",
				"haskell",
				"zig",
				"bash",
				"markdown",
				"markdown_inline",
				"json",
			}
			local alreadyInstalled = require("nvim-treesitter").get_installed()
			local parsersToInstall = vim.iter(ensureInstalled)
				:filter(function(parser)
					return not vim.tbl_contains(alreadyInstalled, parser)
				end)
				:totable()
			require("nvim-treesitter").install(parsersToInstall)
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	},
}
