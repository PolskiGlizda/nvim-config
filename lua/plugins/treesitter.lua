---@type LazySpec
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ---@type string[]
                ensure_installed = {
                    "lua", "vim", "vimdoc",
                    "typescript", "javascript", "tsx",
                    "html", "css",
                    "rust", "go", "c", "python", "haskell", "zig",
                    "bash", "markdown", "markdown_inline", "json",
                },
                highlight = { enable = true },
                indent = { enable = true },
                matchup = { enable = true },
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        opts = {},
    },
}
