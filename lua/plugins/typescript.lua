---@type LazySpec
return {
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", "saghen/blink.cmp" },
        ---@return TSToolsOptions
        opts = function()
            return {
                capabilities = require("blink.cmp").get_lsp_capabilities(),
                settings = {
                    expose_as_code_action = "all",
                    tsserver_file_preferences = {
                        includeInlayParameterNameHints = "all",
                        includeInlayReturnTypeHints = true,
                        --- skip hints when name already matches type
                        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                    },
                },
            }
        end,
    },
    {
        "dmmulroy/ts-error-translator.nvim",
        opts = {},
    },
}
