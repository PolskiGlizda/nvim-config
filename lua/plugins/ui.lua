---@type LazySpec
return {
	{
		"nvim-mini/mini.icons",
		opts = {},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
		lazy = false,
		opts = {
			enabled = true,
			render_modes = { "n", "v", "i", "c" },
			anti_conceal = { enabled = true },
		},
		config = function(_, opts)
			require("render-markdown").setup(opts)
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			cmdline = {
				enabled = true,
				view = "cmdline",
			},
			messages = { enabled = true },
			input = { enabled = true },
			popupmenu = { enabled = false },
			notify = { enabled = true },
			lsp = {
				progress = { enabled = true },
				hover = { enabled = true },
				signature = { enabled = true },
				message = { enabled = true },
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = true,
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-mini/mini.icons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "onedark",
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "os.date('%A %x %I:%M:%S %p')", "location" },
				},
			})
		end,
	},
	{
		"nvimdev/indentmini.nvim",
		config = function()
			require("indentmini").setup()
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"letieu/btw.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local curl = require("plenary.curl")
			local url = "https://v2.jokeapi.dev/joke/Programming?format=txt"
			local cache = vim.fn.stdpath("data") .. "/btw_joke.txt"

			--- show cached joke from last session instantly
			---@type file*?
			local f = io.open(cache, "r")
			if f then
				require("btw").setup({ text = f:read("*a") })
				f:close()
			else
				require("btw").setup()
			end

			--- fetch new joke in background for next session
			curl.get(url, {
				---@param res { status: integer, body: string }
				callback = function(res)
					if res.status == 200 then
						---@type file*?
						local w = io.open(cache, "w")
						if w then
							w:write(res.body)
							w:close()
						end
					end
				end,
			})
		end,
	},
}
