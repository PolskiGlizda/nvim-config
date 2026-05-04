---@type LazySpec
return {
	{
		"yioneko/nvim-vtsls",
		dependencies = { "neovim/nvim-lspconfig", "saghen/blink.cmp" },
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
		config = function()
			--- plugin provides commands like :VtslsRenameFile
			require("vtsls")
		end,
		keys = {
			{ "grO", "<cmd>VtslsOrganizeImports<cr>", desc = "Organize Imports" },
			{ "grU", "<cmd>VtslsRemoveUnused<cr>", desc = "Remove Unused Imports" },
			{ "grM", "<cmd>VtslsAddMissingImports<cr>", desc = "Add Missing Imports" },
			{ "grF", "<cmd>VtslsFixAll<cr>", desc = "Fix All Diagnostics" },
			{ "grR", "<cmd>VtslsRenameFile<cr>", desc = "Rename File" },
			{ "gs", "<cmd>VtslsGotoSourceDefinition<cr>", desc = "Go to Source" },
		},
	},
	{
		"dmmulroy/ts-error-translator.nvim",
		opts = {},
	},
}
