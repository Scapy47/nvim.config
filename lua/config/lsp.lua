require("mason-tool-installer").setup {
    ensure_installed = {
        { 'lua_ls', condition = function() return not os.execute("go version") end }
    },
    integrations = {
        ['mason-lspconfig'] = true
    }
}
