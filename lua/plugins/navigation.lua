---@type LazySpec
return {
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-mini/mini.icons" },
        opts = {},
        config = function()
            local fzf = require("fzf-lua")
            vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Files" })
            vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Grep" })
            vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
            vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
            vim.keymap.set("n", "<leader>fc", fzf.git_commits, { desc = "Git commits" })
            vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "Document symbols" })
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            spec = {
                { "<leader>f", group = "find" },
                { "<leader>g", group = "git" },
                { "<leader>t", group = "trouble" },
                { "<leader>p", group = "project" },
                { "<leader>y", group = "yank" },
            },
        },
    },
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-mini/mini.icons", "benomahony/oil-git.nvim", "JezerM/oil-lsp-diagnostics.nvim" },
        opts = {
            columns = {
                "icon",
                "size",
            },
            default_file_explorer = true,
            view_options = {
                show_hidden = true,
            },
        },
        keys = {
            { "<leader>pv", "<cmd>Oil<CR>", desc = "Open Oil" },
        },
        lazy = false,
    },
    {
        "christoomey/vim-tmux-navigator",
        config = function()
            vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Navigate left" })
            vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Navigate down" })
            vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Navigate up" })
            vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Navigate right" })
        end,
    },
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
}
