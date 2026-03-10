---@type LazySpec
return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {},
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-mini/mini.icons" },
        opts = {},
        keys = {
            { "<leader>td", "<cmd>Trouble diagnostics toggle<CR>", desc = "Project diagnostics" },
            { "<leader>tb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
            { "<leader>ts", "<cmd>Trouble symbols toggle<CR>", desc = "Symbols" },
            { "<leader>tr", "<cmd>Trouble lsp_references toggle<CR>", desc = "LSP references" },
            { "<leader>tt", "<cmd>Trouble todo toggle<CR>", desc = "TODOs" },
        },
    },
}
