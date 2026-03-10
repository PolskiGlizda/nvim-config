---@type LazySpec
return {
    {
        "nvim-mini/mini.icons",
        opts = {},
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            cmdline = {
                enabled = true,
                --- render cmdline at the bottom, not as a float
                view = "cmdline",
            },
            messages = { enabled = true },
            --- disabled — blink.cmp handles completion menu
            popupmenu = { enabled = false },
            notify = { enabled = true },
            lsp = {
                progress = { enabled = true },
                --- disabled — custom K keymap handles hover
                hover = { enabled = false },
                --- disabled — blink.cmp handles signature help
                signature = { enabled = false },
                message = { enabled = true },
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-mini/mini.icons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "onedark",
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "os.date('%A %x %I:%M:%S %p')", "location" },
                },
            })
        end,
    },
    {
        "nvimdev/indentmini.nvim",
        config = function()
            require("indentmini").setup()
        end,
    },
    {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    },
    {
        "letieu/btw.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local curl = require("plenary.curl")
            local url = "https://v2.jokeapi.dev/joke/Programming?format=txt"
            local cache = vim.fn.stdpath("data") .. "/btw_joke.txt"

            --- show cached joke from last session instantly
            ---@type file*?
            local f = io.open(cache, "r")
            if f then
                require("btw").setup({ text = f:read("*a") })
                f:close()
            else
                require("btw").setup()
            end

            --- fetch new joke in background for next session
            curl.get(url, {
                ---@param res { status: integer, body: string }
                callback = function(res)
                    if res.status == 200 then
                        ---@type file*?
                        local w = io.open(cache, "w")
                        if w then
                            w:write(res.body)
                            w:close()
                        end
                    end
                end,
            })
        end,
    },
}
