return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        keys = {
            { "<c-n>", desc = "Increment selection" },
            { "<c-m>", desc = "Decrement selection", mode = "x" },
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "comment",
                    "css",
                    "diff",
                    "git_rebase",
                    "gitattributes",
                    "gitcommit",
                    "gitignore",
                    "go",
                    "html",
                    "java",
                    "javascript",
                    -- "latex",
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "regex",
                    "rust",
                    "scheme",
                    "sql",
                    "v",
                    "vim",
                    "vimdoc",
                    "zig",
                },
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
        dependencies = {
            -- "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
            "m-demare/hlargs.nvim",
            {
                "OXY2DEV/markview.nvim",
                config = function()
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
            },
        },
        lazy = false,
    },
}
