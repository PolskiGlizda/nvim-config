---@type LazySpec
return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    {
        "tpope/vim-sleuth",
    },
    {
        "stevearc/dressing.nvim",
        opts = {},
    },
    {
        "RRethy/vim-illuminate",
        config = function()
            require("illuminate").configure({
                providers = { "lsp", "treesitter" },
                delay = 100,
            })
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
        opts = {
            file_type = { "markdown", "vimwiki" },
        },
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
                if not winid then vim.lsp.buf.hover() end
            end, { desc = "Peek fold" })
        end,
    },
}
