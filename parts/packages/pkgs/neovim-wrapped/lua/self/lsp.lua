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
    vim.keymap.set("n", keys, func, {
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

  nmap("K", vim.lsp.buf.hover, "Hover documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature documentation")

  nmap("<leader>do", vim.diagnostic.open_float, "[d]iagnostics [o]pen")
  nmap("<leader>dp", vim.diagnostic.goto_prev, "[d]iagnostics [p]revious")
  nmap("<leader>dn", vim.diagnostic.goto_next, "[d]iagnostics [n]ext")
  nmap("<leader>dd", telescope.diagnostics, "[d]isplay [d]iagnostics")

  -- nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[w]orkspace [a]dd Folder")
  -- nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[w]orkspace [r]emove Folder")
  -- nmap('<leader>wl', function()
  --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, '[w]orkspace [l]ist Folders')

  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local servers = {
  { "bashls" },
  { "clangd" },
  { "cssls" },
  { "gopls" },
  { "jdtls" },
  { "jedi_language_server" },
  { "jsonls" },
  { "lua_ls" },
  { "marksman" },
  { "nil_ls" },
  { "rust_analyzer" },
  { "sqls" },
  { "superhtml" },
  { "taplo" },
  { "texlab" },
  { "vtsls" },
  { "yamlls" },
  { "zls" },
}

local lspconfig = require("lspconfig")
-- local capabilities = require("blink.cmp").get_lsp_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, server in ipairs(servers) do
  lspconfig[server[1]].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = server.filetypes,
  })
end

-- See `:help vim.diagnostic.Opts`
vim.diagnostic.config({
  virtual_lines = false,
  virtual_text = true,
  signs = {
    enabled = true,
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
  },
})
