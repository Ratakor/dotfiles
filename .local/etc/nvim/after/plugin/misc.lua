local map = vim.keymap.set

-- lazy
map('n', "<leader>l", "<cmd>Lazy<cr>", { desc = "Open Lazy" })

-- Telescope
local telescope = require("telescope.builtin")
map('n', "<leader>f", telescope.find_files, { desc = "Find files" })
map('n', "<C-g>", telescope.git_files)

-- NERDTree (see their README)
map('n', "<F2>", ":NERDTreeToggle<CR>")
vim.cmd("autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif")

-- Undotree
map('n', "<F3>", ":UndotreeToggle<CR>")

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

map('n', "<C-t>", function()
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

require("Comment.ft").set("c", { "/*%s*/", "//%s" })
