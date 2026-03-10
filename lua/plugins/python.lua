---@type LazySpec
return {
    {
        "linux-cultist/venv-selector.nvim",
        branch = "regexp",
        dependencies = { "neovim/nvim-lspconfig", "ibhagwan/fzf-lua" },
        opts = {
            settings = {
                options = {
                    notify_user_on_venv_activation = true,
                },
            },
        },
        keys = {
            { "<leader>vs", "<cmd>VenvSelect<CR>", desc = "Select venv" },
        },
    },
}
