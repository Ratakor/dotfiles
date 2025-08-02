vim.opt.updatetime = 1000
vim.opt.signcolumn = "yes"
vim.g.completion_enable_auto_popup = 1

-- Auto-format on write
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     callback = function ()
--         vim.lsp.buf.format()
--     end,
-- })

local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end
        vim.keymap.set('n', keys, func, {
            noremap = true,
            silent = true,
            buffer = bufnr,
            desc = desc,
        })
    end

    local telescope = require("telescope.builtin")

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    nmap("<leader>r", vim.lsp.buf.rename, "[r]ename")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")

    nmap("gD", vim.lsp.buf.declaration, "[g]o to [D]eclaration")
    nmap("gd", vim.lsp.buf.definition, "[g]o to [d]efinition")
    -- nmap("gd", telescope.lsp_definitions, "[g]o to [d]efinition")
    nmap("gr", telescope.lsp_references, "[g]o to [r]eferences")
    nmap("gi", telescope.lsp_implementations, "[g]o to [i]mplementation")
    nmap("<leader>td", telescope.lsp_type_definitions, "[t]ype [d]efinition")
    nmap("<leader>ds", telescope.lsp_document_symbols, "[d]ocument [s]ymbols")
    nmap("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")

    nmap("K", vim.lsp.buf.hover, "Hover documenation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature documenation")

    nmap("<leader>do", vim.diagnostic.open_float, "[d]iagnostics [o]pen")
    nmap("<leader>dp", vim.diagnostic.goto_prev, "[d]iagnostics [p]revious")
    nmap("<leader>dn", vim.diagnostic.goto_next, "[d]iagnostics [n]ext")
    nmap("<leader>dd", telescope.diagnostics, "[d]isplay [d]iagnostics")

    -- nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[w]orkspace [a]dd Folder")
    -- nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[w]orkspace [r]emove Folder")
    -- nmap('<leader>wl', function()
    --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, '[w]orkspace [l]ist Folders')

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

-- https://github.com/mason-org/mason-lspconfig.nvim/tree/5c142464ea29ceca3b4d77d2c80b9e8e3fca02d9?tab=readme-ov-file#available-lsp-servers
-- match lua/plugins/lsp.lua
local servers = {
    "bashls",
    "clangd",
    "cssls",
    "gopls",
    -- "html",
    "jdtls",
    "jedi_language_server",
    "lua_ls",
    "marksman",
    "rust_analyzer",
    "sqls",
    "texlab",
    "vtsls",
    "zls",
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, server_name in ipairs(servers) do
    require("lspconfig")[server_name].setup({
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

require("lspconfig")["superhtml"].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "superhtml", "lsp" },
    filetypes = { "html", "shtml", "xhtml", "htm" },
})

-- Required by cmp for using tab to choose completion
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Load snippets
require("luasnip.loaders.from_snipmate").lazy_load()

local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),

    sources = {
        { name = "buffer" },
        { name = "calc" },
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "path" },
        { name = "treesitter" },
    },
})

-- See `:help vim.diagnostic.Opts`
vim.diagnostic.config({
    virtual_lines = false,
    virtual_text = true,
    signs = {
        enabled = true,
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
        },
        texthl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
            [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
            [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
        },
    },
})
