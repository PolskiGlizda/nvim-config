---@type LazySpec
return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        config = function()
            require("conform").setup({
                ---@type table<string, string[]>
                formatters_by_ft = {
                    python = { "ruff_format" },
                    lua = { "stylua" },
                    typescript = { "prettier" },
                    javascript = { "prettier" },
                    typescriptreact = { "prettier" },
                    javascriptreact = { "prettier" },
                    css = { "prettier" },
                    html = { "prettier" },
                    json = { "prettier" },
                    markdown = { "prettier" },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                },
            })
            vim.keymap.set("n", "<leader>gf", function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end, { desc = "Format" })
        end,
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                python = { "mypy" },
            }
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
                ---@param _ vim.api.keyset.create_autocmd.callback_args
                callback = function(_)
                    require("lint").try_lint()
                end,
            })
        end,
    },
}
