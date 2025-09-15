local map = vim.keymap.set

-- gc/gcc magic comment
require("Comment").setup({ ignore = "^$" })
local comment = require("Comment.ft")
comment.set("c", { "/*%s*/", "//%s" })
comment.set("nov", { ";%s" })

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

-- TODO: cpuburn when no internet
-- TODO: build :Copilot auth
-- require("copilot").setup({
--     panel = { enabled = false },
--     suggestion = {
--         enabled = true,
--         auto_trigger = true,
--         keymap = {
--             accept = "<C-h>",
--             dismiss = "<C-l>",
--         },
--     },
-- })

vim.opt.timeout = true
vim.opt.timeoutlen = 300
require("which-key").setup()

vim.g.vimtex_view_method = "zathura"

require("comfy-line-numbers").setup({
  hidden_file_types = {
    "undotree",
    -- "NERD_tree",
    "",
  },
})

-- TODO: switch to chadtree or neo-tree?
-- NERDTree (see their README)
map("n", "<F2>", ":NERDTreeToggle<CR>")
vim.cmd(
  "autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif"
)

-- Undotree: History Visualizer
map("n", "<F3>", ":UndotreeToggle<CR>")

-- TODO
-- {
--     "NotAShelf/syntax-gaslighting.nvim",
--     enabled = false,
--     config = function()
--         vim.api.nvim_set_hl(0, "GaslightingUnderline", { fg = "#d79921" })
--         require("syntax-gaslighting").setup({})
--     end,
-- }

-- Disable auto-format on save for zig, too slow
vim.g.zig_fmt_autosave = 0

-- Starting screen
vim.g.startify_custom_header = {
  "   ▄▄▄   ▄▄▄· ▄▄▄▄▄ ▄▄▄· ▄ •▄       ▄▄▄  ",
  "   ▀▄ █·▐█ ▀█ •██  ▐█ ▀█ █▌▄▌▪▪     ▀▄ █·",
  "   ▐▀▀▄ ▄█▀▀█  ▐█.▪▄█▀▀█ ▐▀▀▄· ▄█▀▄ ▐▀▀▄ ",
  "   ▐█•█▌▐█ ▪▐▌ ▐█▌·▐█ ▪▐▌▐█.█▌▐█▌.▐▌▐█•█▌",
  "   .▀  ▀ ▀  ▀  ▀▀▀  ▀  ▀ ·▀  ▀ ▀█▄▀▪.▀  ▀",
}
