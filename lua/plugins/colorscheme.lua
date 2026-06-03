---@type LazySpec
return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night",
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
				},
			})
			vim.cmd("colorscheme tokyonight")
		end,
	},
}
