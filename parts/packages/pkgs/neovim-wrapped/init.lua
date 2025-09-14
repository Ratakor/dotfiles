-- This is roughly a copy of my nvim config on artix
-- it misses recent update I did, there is no lazy loading and everything is in one file
-- TODO: merge with lua/ & cleanup package.nix

vim.loader.enable()

-------------------------------------------------------------------------------
-- settings.lua
-------------------------------------------------------------------------------

local map = vim.keymap.set

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 8 -- n of whitespace in \t
vim.opt.shiftwidth = 4 -- n of whitespace for indent
vim.opt.softtabstop = 4 -- n of whitespace to delete with backspace
vim.opt.expandtab = true -- \t -> whitespaces

-- Restrict mouse
vim.cmd("aunmenu PopUp")
map({ "n", "v", "i" }, "<Middlemouse>", "<Nop>")

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
        vim.opt_local.softtabstop = 8
        vim.opt_local.expandtab = false
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lisp", "scheme", "clojure", "html", "css" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
    end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "html", "markdown", "tex" },
--     callback = function()
--         vim.opt_local.spell = true
--     end,
-- })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.nov" },
    callback = function()
        vim.opt_local.filetype = "nov"
    end,
})

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "ZQ", ":q<CR>")
map({ "n", "v" }, "<space>", "<Nop>", { silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Remap ; to : to avoid shifting
map("n", ";", ":")
map("v", ";", ":")

local function abbrev(mode, lhs, rhs)
    vim.cmd(mode .. "abbrev " .. lhs .. " " .. rhs)
end

abbrev("c", "Q", "q")
abbrev("c", "W", "w")
abbrev("i", "reutnr", "return")
abbrev("i", "TOOD", "TODO")
abbrev("i", "cosnt", "const")
abbrev("i", "swtich", "switch")

-------------------------------------------------------------------------------
-- colorscheme.lua
-------------------------------------------------------------------------------

require("gruvbox").setup({
    italic = {
        strings = false,
        comments = false,
    },
    transparent_mode = true,
})

-------------------------------------------------------------------------------
-- debug.lua
-------------------------------------------------------------------------------
-- Put a print statement with g?p or g?v
require("debugprint").setup()

-- TODO
-- "mfussenegger/nvim-dap",

-------------------------------------------------------------------------------
-- lsp.lua
-------------------------------------------------------------------------------
require("neodev").setup()

--------------------------------------------------------------------------------
-- misc.lua
--------------------------------------------------------------------------------
require("nvim-web-devicons").setup()

-- gc/gcc magic comment
require("Comment").setup({ ignore = "^$" })

-- HUD for git in vim
require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "" },
    },
})

-- git in vim
--"tpope/vim-fugitive",
--"tpope/vim-rhubarb",

-- require("telescope").load_extension("fzf")

-- TODO: build :Copilot auth
require("copilot").setup({
    panel = { enabled = false },
    suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
            accept = "<C-h>",
            dismiss = "<C-l>",
        },
    },
})

vim.opt.timeout = true
vim.opt.timeoutlen = 300
require("which-key").setup()

vim.g.vimtex_view_method = "zathura"

-- {
--     "gruvw/strudel.nvim",
--     cmd = "StrudelLaunch",
--     build = "npm install",
--     config = function()
--         require("strudel").setup({
--             update_on_save = true,
--             -- headless = true,
--             browser_data_dir = (os.getenv("XDG_CACHE_HOME") or "~/.cache") .. "/strudel-nvim",
--         })
--     end,
-- },

--------------------------------------------------------------------------------
-- noice.lua
--------------------------------------------------------------------------------
require("noice").setup({
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
    presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
    },
    routes = {
        {
            filter = {
                event = "msg_show",
                kind = "",
            },
            opts = { skip = true },
        },
    },
})

-- require("notify").setup({})

-------------------------------------------------------------------------------
-- treesitter.lua
-------------------------------------------------------------------------------

-- TODO
-- keys = {
--     { "<c-n>", desc = "Increment Selection" },
--     { "<c-m>", desc = "Decrement Selection", mode = "x" },
-- },
require("nvim-treesitter.configs").setup({
    ensure_installed = {},
    auto_install = false,
    highlight = {
        enable = true,
        disable = { "latex" }, -- done by vimtex
        additional_vim_regex_highlighting = { "latex", "markdown" },
    },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-N>",
            node_incremental = "<C-N>",
            scope_incremental = false,
            node_decremental = "<C-M>",
        },
    },
})

-------------------------------------------------------------------------------
-- colors.lua
-------------------------------------------------------------------------------

local colors = require("gruvbox").palette

vim.opt.background = "dark"
vim.cmd("colorscheme gruvbox")

require("hlargs").setup({
    color = colors.neutral_orange,
})

require("scrollbar").setup({
    marks = {
        Search = { color = colors.neutral_orange },
        Error = { color = colors.neutral_red },
        Warn = { color = colors.neutral_yellow },
        Info = { color = colors.neutral_pink },
        Hint = { color = colors.neutral_cyan },
        Misc = { color = colors.neutral_purple },
    },
    handlers = {
        cursor = false,
        handle = false,
    },
})

local empty = require("lualine.component"):extend()
function empty:draw(default_highlight)
    self.status = ""
    self.applied_separator = ""
    self:apply_highlights(default_highlight)
    self:apply_section_separators()
    return self.status
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
    for name, section in pairs(sections) do
        local left = name:sub(9, 10) < "x"
        for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
            table.insert(section, pos * 2, {
                empty,
                color = {
                    fg = colors.neutral_white,
                    bg = colors.neutral_white,
                },
            })
        end
        for id, comp in ipairs(section) do
            if type(comp) ~= "table" then
                comp = { comp }
                section[id] = comp
            end
            comp.separator = left and { right = "" } or { left = "" }
        end
    end
    return sections
end

local function modified()
    if vim.bo.modified then
        return "+"
    elseif vim.bo.modifiable == false or vim.bo.readonly == true then
        return "-"
    end
    return ""
end

local transparent = require("lualine.themes.gruvbox")
transparent.inactive.c.bg = "nil"
transparent.visual.c.bg = "nil"
transparent.replace.c.bg = "nil"
transparent.normal.c.bg = "nil"
transparent.insert.c.bg = "nil"
transparent.command.c.bg = "nil"

require("lualine").setup({
    options = {
        theme = transparent,
        component_separators = "",
        section_separators = { left = "", right = "" },
    },
    sections = process_sections({
        lualine_a = { "mode" },
        lualine_b = {
            "branch",
            "diff",
            { "filename", file_status = false, path = 1 },
            {
                "diagnostics",
                source = { "nvim" },
                sections = { "error" },
                symbols = { error = "E " },
                diagnostics_color = {
                    error = {
                        bg = colors.neutral_red,
                        fg = colors.dark0,
                        gui = "bold",
                    },
                },
                -- on_click = function()
                --     vim.diagnostic.goto_prev()
                -- end
            },
            {
                "diagnostics",
                source = { "nvim" },
                sections = { "warn" },
                symbols = { warn = "W " },
                diagnostics_color = {
                    warn = {
                        bg = colors.neutral_orange,
                        fg = colors.dark0,
                        gui = "bold",
                    },
                },
                -- on_click = function()
                --     vim.diagnostic.goto_next()
                -- end
            },
            { modified, color = { bg = colors.neutral_purple } },
            {
                "%w",
                cond = function()
                    return vim.wo.previewwindow
                end,
            },
            {
                "%r",
                cond = function()
                    return vim.bo.readonly
                end,
            },
            {
                "%q",
                cond = function()
                    return vim.bo.buftype == "quickfix"
                end,
            },
        },
        lualine_c = {},
        lualine_x = { "fileformat" },
        lualine_y = { "filetype", "progress" },
        lualine_z = { "location" },
    }),
})

--------------------------------------------------------------------------------
-- lsp.lua
--------------------------------------------------------------------------------

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
    nmap("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")

    nmap("gD", vim.lsp.buf.declaration, "[g]o to [D]eclaration")
    nmap("gd", telescope.lsp_definitions, "[g]o to [d]efinition")
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

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
end

-- https://github.com/mason-org/mason-lspconfig.nvim/tree/5c142464ea29ceca3b4d77d2c80b9e8e3fca02d9?tab=readme-ov-file#available-lsp-servers
-- match lua/plugins/lsp.lua
local servers = {
    "bashls",
    "clangd",
    "cssls",
    "gopls",
    -- "html",
    "jedi_language_server",
    "lua_ls",
    "marksman",
    "rust_analyzer",
    "sqls",
    "texlab",
    "vtsls",
    "zls",
    "nil_ls",
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

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
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
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
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

--------------------------------------------------------------------------------
-- misc.lua
--------------------------------------------------------------------------------

local map = vim.keymap.set

-- lazy
map("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = "Open Lazy" })

-- Telescope
local telescope = require("telescope.builtin")
map("n", "<leader>f", telescope.find_files, { desc = "Find files" })
map("n", "<C-g>", telescope.git_files)

-- NERDTree (see their README)
map("n", "<F2>", ":NERDTreeToggle<CR>")
vim.cmd(
    "autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif"
)

-- Undotree
map("n", "<F3>", ":UndotreeToggle<CR>")

-- Disable auto-format on save for zig, too slow
vim.g.zig_fmt_autosave = 0

require("neotest").setup({
    adapters = {
        require("neotest-zig"),
    },
    summary = {
        enabled = true,
        animated = true,
        follow = true,
        expand_error = true,

        mappings = {
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            output = "o",
            short = "O",
            attach = "a",
            jumpto = { "i", "<C-]>" },
            stop = "u",
            run = "r",
            debug = "d",
            mark = "m",
            run_marked = "R",
            debug_marked = "D",
            clear_marked = "M",
            target = "t",
            clear_target = "T",
            next_failed = "J",
            prev_failed = "K",
        },
    },
})

map("n", "<C-t>", function()
    -- require("neotest").run.run()
    require("neotest").summary.toggle()
    local win = vim.fn.bufwinid("Neotest Summary")
    if win > -1 then
        vim.api.nvim_set_current_win(win)
    end
end)

vim.g.startify_custom_header = {
    "   ▄▄▄   ▄▄▄· ▄▄▄▄▄ ▄▄▄· ▄ •▄       ▄▄▄  ",
    "   ▀▄ █·▐█ ▀█ •██  ▐█ ▀█ █▌▄▌▪▪     ▀▄ █·",
    "   ▐▀▀▄ ▄█▀▀█  ▐█.▪▄█▀▀█ ▐▀▀▄· ▄█▀▄ ▐▀▀▄ ",
    "   ▐█•█▌▐█ ▪▐▌ ▐█▌·▐█ ▪▐▌▐█.█▌▐█▌.▐▌▐█•█▌",
    "   .▀  ▀ ▀  ▀  ▀▀▀  ▀  ▀ ·▀  ▀ ▀█▄▀▪.▀  ▀",
}

local comment = require("Comment.ft")
comment.set("c", { "/*%s*/", "//%s" })
comment.set("nov", { ";%s" })

-- local strudel = require("strudel")
-- map("n", "<leader>sl", strudel.launch, { desc = "Launch Strudel" })
-- map("n", "<leader>sq", strudel.quit, { desc = "Quit Strudel" })
-- map("n", "<leader>st", strudel.toggle, { desc = "Strudel Toggle Play/Stop" })
-- map("n", "<leader>su", strudel.update, { desc = "Strudel Update" })
-- map("n", "<leader>ss", strudel.stop, { desc = "Strudel Stop Playback" })
-- map("n", "<leader>sb", strudel.set_buffer, { desc = "Strudel set current buffer" })
-- map("n", "<leader>sx", strudel.execute, { desc = "Strudel set current buffer and update" })
