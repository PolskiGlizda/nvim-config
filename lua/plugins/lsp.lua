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

            -- restrict htmx to html only to avoid hover conflicts with ts
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

            -- web
            vim.lsp.enable("tailwindcss")
            vim.lsp.enable("emmet_language_server")
            vim.lsp.enable("cssls")
            vim.lsp.enable("html")
            vim.lsp.enable("htmx")

            -- scripting
            vim.lsp.enable("bashls")
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("vimls")

            -- python: basedpyright for navigation, ruff for linting
            vim.lsp.enable("basedpyright")
            vim.lsp.enable("ruff")
            vim.lsp.config("basedpyright", {
                settings = {
                    ---@class BasedPyrightSettings
                    basedpyright = {
                        --- disabled in favour of mypy
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
                        --- disable built-in schema store in favour of schemastore.nvim
                        schemaStore = { enable = false, url = "" },
                        schemas = require("schemastore").yaml.schemas(),
                    },
                },
            })

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
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.INFO] = "",
                        [vim.diagnostic.severity.HINT] = "󱠃",
                    },
                }
            })
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            --- hls excluded — install via GHCup instead
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
            },
        },
    },
    {
        "mason-org/mason.nvim",
        ---@class MasonSettings
        ---@field ui { icons: { package_installed: string, package_pending: string, package_uninstalled: string } }
        ---@field pip { upgrade_pip: boolean }
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
                { path = "${3rd}/luv/library", words = { "vim%.uv" } }
            },
        },
    },
}
