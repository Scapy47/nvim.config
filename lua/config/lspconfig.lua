local lspconfig = require('lspconfig')

local capabilities = vim.tbl_deep_extend('force', {},
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities()
)

local function on_attach(client, bufnr)
    --  PERF: Format on save
    if client.supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd('bufWritePre', {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
            end
        })
    end
end


local servers = {
    lua_ls = {},
    clangd = {}
}

-- TODO: add mason-tool-installer

vim.tbl_map(function(server_name)
    local config = servers[server_name]
    config.on_attach = on_attach
    config.capabilities = capabilities
    lspconfig[server_name].setup(config)
end, vim.tbl_keys(servers))

require("mason-lspconfig").setup {
    automatic_installation = false,
    ensure_installed = {}, -- explicitly empty (handled by mason-tool-installer)
    handlers = {
        function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = capabilities
            server.on_attach = on_attach
            lspconfig[server_name].setup(server)
        end
    }
}
