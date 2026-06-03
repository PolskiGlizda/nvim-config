---@type LazySpec
return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
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
				"prisma",
			}
			local alreadyInstalled = require("nvim-treesitter").get_installed()
			local parsersToInstall = vim.iter(ensureInstalled)
				:filter(function(parser)
					return not vim.tbl_contains(alreadyInstalled, parser)
				end)
				:totable()
			require("nvim-treesitter").install(parsersToInstall)

			-- manual textobjects activation
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local select = require("nvim-treesitter-textobjects.select")
					local move = require("nvim-treesitter-textobjects.move")

					-- selection
					local maps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					}
					for map, query in pairs(maps) do
						vim.keymap.set({ "x", "o" }, map, function()
							select.select_textobject(query, "stops", bufnr)
						end, { buffer = bufnr, desc = map })
					end

					-- movement
					vim.keymap.set("n", "]f", function()
						move.goto_next_start("@function.outer", "python", bufnr)
					end, { buffer = bufnr })
					vim.keymap.set("n", "[f", function()
						move.goto_previous_start("@function.outer", "python", bufnr)
					end, { buffer = bufnr })
				end,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	},
}
