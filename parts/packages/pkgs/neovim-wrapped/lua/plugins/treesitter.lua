return {
    {
        -- TODO: do not lazy load
        -- TODO: this keep erroring because it is loaded after nvim-treesitter
        enabled = false,
        "markview.nvim",
        after = function()
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
        end,
        -- lazy = false,
    },
    -- {
    --     "rainbow-delimiters.nvim",
    -- },
    {
        "hlargs.nvim",
        after = function()
            local colors = require("gruvbox").palette

            require("hlargs").setup({
                color = colors.neutral_orange,
            })
        end,
    },
    {
        "nvim-treesitter",
        -- lazy = false,
        -- build = ":TSUpdate",
        -- keys = {
        --     { "<c-n>", desc = "Increment selection" },
        --     { "<c-m>", desc = "Decrement selection", mode = "x" },
        -- },
        before = function()
            LZN.trigger_load("markview.nvim")
            LZN.trigger_load("rainbow-delimiters.nvim")
            LZN.trigger_load("hlargs-nvim")
        end,
        after = function()
            require("nvim-treesitter.configs").setup({
                -- ensure_installed = {
                --     "bash",
                --     "c",
                --     "comment",
                --     "css",
                --     "diff",
                --     "git_rebase",
                --     "gitattributes",
                --     "gitcommit",
                --     "gitignore",
                --     "go",
                --     "html",
                --     "java",
                --     "javascript",
                --     -- "latex",
                --     "lua",
                --     "make",
                --     "markdown",
                --     "markdown_inline",
                --     "python",
                --     "regex",
                --     "rust",
                --     "scheme",
                --     "sql",
                --     "v",
                --     "vim",
                --     "vimdoc",
                --     "zig",
                -- },
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
        end,
    },
}
