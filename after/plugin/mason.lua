local mason = require("mason")
local masonLspConfig = require("mason-lspconfig")
mason.setup()
masonLspConfig.setup({
    ensure_installed = {
        "lua_ls",
        "clangd",
        "cmake",
        "emmet_ls",
        "cssls",
        "elmls",
        "pylsp",
        "tsserver",
    },
})
