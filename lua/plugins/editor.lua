---@type LazySpec
return {
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"lewis6991/async.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
		keys = {
			{
				"<leader>re",
				":Refactor extract ",
				mode = "x",
				desc = "Extract function",
			},
			{
				"<leader>rf",
				":Refactor extract_to_file ",
				mode = "x",
				desc = "Extract function to file",
			},
			{
				"<leader>rv",
				":Refactor extract_var ",
				mode = "x",
				desc = "Extract variable",
			},
			{
				"<leader>ri",
				":Refactor inline_var",
				mode = { "n", "x" },
				desc = "Inline variable",
			},
			{
				"<leader>rb",
				":Refactor extract_block ",
				mode = "n",
				desc = "Extract block",
			},
			{
				"<leader>rB",
				":Refactor extract_block_to_file ",
				mode = "n",
				desc = "Extract block to file",
			},
		},
	},
	{
		"LunarVim/bigfile.nvim",
		opts = {
			filesize = 2, -- MiB
		},
	},
	{
		"MagicDuck/grug-far.nvim",

	    opts = { headerMaxWidth = 80 },
	    keys = {
	        {
	            "<leader>s",
	            function()
	                local grug = require("grug-far")
	                local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
	                grug.open({
	                    transient = true,
	                    prefills = {
	                        filesFilter = ext and ext ~= "" and ("*." .. ext) or nil,
	                    },
	                })
	            end,
	            mode = { "n", "v" },
	            desc = "Search and replace",
	        },
	    },
	},
	{
	    "windwp/nvim-autopairs",

		event = "InsertEnter",
		opts = {},
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},
	{
		"monaqa/dial.nvim",
		keys = {
			{
				"<C-a>",
				function()
					require("dial.map").manipulate("increment", "normal")
				end,
				desc = "Increment",
			},
			{
				"<C-x>",
				function()
					require("dial.map").manipulate("decrement", "normal")
				end,
				desc = "Decrement",
			},
			{
				"g<C-a>",
				function()
					require("dial.map").manipulate("increment", "gnormal")
				end,
				desc = "Increment (additive)",
			},
			{
				"g<C-x>",
				function()
					require("dial.map").manipulate("decrement", "gnormal")
				end,
				desc = "Decrement (additive)",
			},
			{
				"<C-a>",
				function()
					require("dial.map").manipulate("increment", "visual")
				end,
				mode = "v",
				desc = "Increment",
			},
			{
				"<C-x>",
				function()
					require("dial.map").manipulate("decrement", "visual")
				end,
				mode = "v",
				desc = "Decrement",
			},
			{
				"g<C-a>",
				function()
					require("dial.map").manipulate("increment", "gvisual")
				end,
				mode = "v",
				desc = "Increment (additive)",
			},
			{
				"g<C-x>",
				function()
					require("dial.map").manipulate("decrement", "gvisual")
				end,
				mode = "v",
				desc = "Decrement (additive)",
			},
		},
	},
	{
		"chrisgrieser/nvim-spider",
		keys = {
			{
				"w",
				"<cmd>lua require('spider').motion('w')<cr>",
				mode = { "n", "o", "x" },
				desc = "Spider-w",
			},
			{
				"e",
				"<cmd>lua require('spider').motion('e')<cr>",
				mode = { "n", "o", "x" },
				desc = "Spider-e",
			},
			{
				"b",
				"<cmd>lua require('spider').motion('b')<cr>",
				mode = { "n", "o", "x" },
				desc = "Spider-b",
			},
			{
				"ge",
				"<cmd>lua require('spider').motion('ge')<cr>",
				mode = { "n", "o", "x" },
				desc = "Spider-ge",
			},
		},
	},
	{
		"tpope/vim-sleuth",
	},
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"danymat/neogen",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			snippet_engine = "nvim",
			languages = {
				python = { template = { annotation_convention = "google_docstrings" } },
				typescript = { template = { annotation_convention = "jsdoc" } },
				lua = { template = { annotation_convention = "ldoc" } },
				go = { template = { annotation_convention = "godoc" } },
				rust = { template = { annotation_convention = "rustdoc" } },
			},
		},
		keys = {
			{
				"<leader>ng",
				function()
					require("neogen").generate()
				end,
				desc = "Generate annotation",
			},
		},
	},
	{
		"andymass/vim-matchup",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			require("ufo").setup({
				---@return string[]
				provider_selector = function()
					return { "lsp", "indent" }
				end,
			})
			vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
			vim.keymap.set("n", "zK", function()
				--- peek fold or fall back to lsp hover
				---@type integer?
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end, { desc = "Peek fold" })
		end,
	},
}
