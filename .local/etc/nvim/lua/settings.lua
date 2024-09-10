local map = vim.keymap.set

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 8 -- n of whitespace in \t
vim.opt.shiftwidth = 4 -- n of whitespace for indent
vim.opt.softtabstop = 4 -- n of whitespace to delete with backspace
vim.opt.expandtab = true -- \t -> whitespaces

-- Restrict mouse
vim.cmd("aunmenu PopUp")
map({ 'n', 'v', 'i' }, "<Middlemouse>", "<Nop>")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = { 80, 100 }
--vim.opt.textwidth = 79
vim.opt.title = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
vim.opt.ttimeoutlen = 10
vim.opt.list = true
vim.opt.listchars = "tab:| ,space:·" --,eol:$ --↴
vim.opt.path = ".,/usr/include,/usr/local/include,,"
vim.opt.foldenable = false
vim.api.nvim_create_autocmd("FileType", { command = "setl fo-=ro fo+=tc" })

-- Toggle between tabs and spaces
local using_space = true
vim.api.nvim_create_user_command("ToggleIndent", function()
    if using_space then
        vim.opt.shiftwidth = 8
        vim.opt.softtabstop = 8
        vim.opt.expandtab = false
    else
        vim.opt.shiftwidth = 4
        vim.opt.softtabstop = 4
        vim.opt.expandtab = true
    end
    using_space = not using_space
end, {})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "asm", "make", "sh" },
    callback = function()
        vim.opt_local.tabstop = 8
        vim.opt_local.shiftwidth = 8
        vim.opt_local.expandtab = false
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lisp", "scheme", "clojure", "html", "css" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
    end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "html", "markdown", "tex" },
--     callback = function()
--         vim.opt_local.spell = true
--     end,
-- })

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

map('n', "<C-d>", "<C-d>zz")
map('n', "<C-u>", "<C-u>zz")
map('n', "ZQ", ":q<CR>")
map({ 'n', 'v' }, "<space>", "<Nop>", { silent = true })
map('n', "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map('n', "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map('x', "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map('o', "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Better indenting
map('v', "<", "<gv")
map('v', ">", ">gv")

-- Remap ; to : to avoid shifting
map('n', ";", ":")
map('v', ";", ":")

local function abbrev(mode, lhs, rhs)
    vim.cmd(mode .. "abbrev " .. lhs .. " " .. rhs)
end

abbrev('c', "Q", "q")
abbrev('c', "W", "w")
abbrev('i', "reutnr", "return")
abbrev('i', "TOOD", "TODO")
abbrev('i', "cosnt", "const")
abbrev('i', "swtich", "switch")
