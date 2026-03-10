---@type LazySpec
return {
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
            { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, desc = "Increment" },
            { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, desc = "Decrement" },
            { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "Increment (additive)" },
            { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "Decrement (additive)" },
            { "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, mode = "v", desc = "Increment" },
            { "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, mode = "v", desc = "Decrement" },
            { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = "v", desc = "Increment (additive)" },
            { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = "v", desc = "Decrement (additive)" },
        },
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
        "OXY2DEV/helpview.nvim",
        ft = "help",
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
            { "<leader>ng", function() require("neogen").generate() end, desc = "Generate annotation" },
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
