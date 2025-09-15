local colors = require("gruvbox").palette
require("hlargs").setup({
    color = colors.neutral_orange,
})

local presets = require("markview.presets")
require("markview").setup({
    preview = {
        modes = { "i", "n", "no", "c" },
        hybrid_modes = { "i" },
        linewise_hybrid_mode = true,
        edit_range = { 0, 0 },
    },
    markdown = {
        headings = presets.headings.glow,
        tables = presets.tables.single,
        -- horizontal_rules = presets.horizontal_rules.thin,
    },
})

require("nvim-treesitter.configs").setup({
    modules = {},
    sync_install = false,
    ignore_install = {},
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
