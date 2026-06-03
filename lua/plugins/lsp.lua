---@type LazySpec
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp", "b0o/schemastore.nvim" },
		config = function()
			-- apply blink.cmp capabilities to all servers
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			-- restrict htmx to html only
			vim.lsp.config("htmx", {
				filetypes = { "html" },
			})

			-- general purpose
			vim.lsp.enable("hls")
			vim.lsp.enable("rust-analyzer")
			vim.lsp.enable("gopls")
			vim.lsp.enable("zls")
			vim.lsp.enable("asm_lsp")
			vim.lsp.enable("clangd")
			vim.lsp.enable("terraform-ls")

			-- vtsls: better typescript support - SINGLE POINT OF ACTIVATION
			vim.lsp.enable("vtsls")
			vim.lsp.config("vtsls", {
				settings = {
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						inlayHints = {
							parameterNames = { enabled = "all" },
							variableTypes = { enabled = true },
						},
					},
					vtsls = {
						experimental = {
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
				},
			})

			-- explicitly disable ts_ls (which often auto-attaches in 0.13)
			vim.lsp.config("ts_ls", {
				enabled = false,
				handlers = {
					["textDocument/publishDiagnostics"] = function() end,
				},
			})

			-- web
			vim.lsp.enable("tailwindcss")
			vim.lsp.enable("emmet_language_server")
			vim.lsp.enable("cssls")
			vim.lsp.enable("html")
			vim.lsp.enable("htmx")

			-- tailwindcss: reduce noise and prevent race conditions
			vim.lsp.config("tailwindcss", {
				settings = {
					tailwindCSS = {
						minCharacters = 2,
					},
				},
			})

			-- scripting
			vim.lsp.enable("bashls")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("vimls")

			-- python: basedpyright for navigation, ruff for linting
			vim.lsp.enable("basedpyright")
			vim.lsp.enable("ruff")
			vim.lsp.config("basedpyright", {
				settings = {
					basedpyright = {
						typeCheckingMode = "off",
					},
				},
			})

			-- data / config
			vim.lsp.enable("jsonls")
			vim.lsp.enable("yamlls")
			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})
			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						schemaStore = { enable = false, url = "" },
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			})
			vim.lsp.enable("prismals")

			-- enable inlay hints globally with toggle
			vim.lsp.inlay_hint.enable()
			vim.keymap.set("n", "<leader>ih", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, { desc = "Toggle inlay hints" })

			vim.diagnostic.config({
				virtual_lines = true,
				virtual_text = false,
				update_in_insert = false,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = require("mini.icons").get("lsp", "error"),
						[vim.diagnostic.severity.WARN] = require("mini.icons").get("lsp", "warning"),
						[vim.diagnostic.severity.INFO] = require("mini.icons").get("lsp", "information"),
						[vim.diagnostic.severity.HINT] = require("mini.icons").get("lsp", "hint"),
					},
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSPs
					"rust-analyzer",
					"gopls",
					"tailwindcss-language-server",
					"emmet-language-server",
					"bash-language-server",
					"clangd",
					"cssls",
					"html",
					"htmx-lsp",
					"lua-language-server",
					"basedpyright",
					"ruff",
					"zls",
					"asm-lsp",
					"vim-language-server",
					"jsonls",
					"yaml-language-server",
					"terraform-ls",
					"vtsls",
					"prismals",
					-- Formatters
					"stylua",
					"prettier",
					-- Linters
					"mypy",
				},
				auto_update = true,
				run_on_start = true,
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"rust_analyzer",
				"gopls",
				"tailwindcss",
				"emmet_language_server",
				"bashls",
				"clangd",
				"cssls",
				"html",
				"htmx",
				"lua_ls",
				"basedpyright",
				"ruff",
				"zls",
				"asm_lsp",
				"vimls",
				"jsonls",
				"yamlls",
				"terraformls",
				"vtsls",
			},
		},
	},
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			pip = {
				upgrade_pip = true,
			},
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
