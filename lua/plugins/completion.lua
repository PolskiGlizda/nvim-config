---@type LazySpec
return {
    {
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "1.*",
        ---@type blink.cmp.Config
        opts = {
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = { documentation = { auto_show = true } },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "lazydev" },
                providers = {
                    lsp = {
                        name = "lsp",
                        enabled = true,
                        module = "blink.cmp.sources.lsp",
                        score_offset = 1000,
                    },
                    snippets = {
                        opts = {
                            friendly_snippets = true,
                            search_paths = { vim.fn.stdpath("config") .. "/snippets" },
                        },
                    },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            keymap = {
                preset = "default",
                ["<Tab>"] = { "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
            },
            fuzzy = { implementation = "prefer_rust" },
            signature = { enabled = true },
        },
        opts_extend = { "sources.default" },
    },
}
