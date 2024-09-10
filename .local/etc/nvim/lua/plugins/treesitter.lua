return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
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
                    -- "javascript",
                    "latex",
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "regex",
                    "rust",
                    "scheme",
                    "sql",
                    "vim",
                    "vimdoc",
                    "zig",
                },
                auto_install = false,
                highlight = { enable = true },
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
                additional_vim_regex_highlighting = false,
                rainbow = {
                    enable = true,
                    extended_mode = true,
                },
            }
        end,
        dependencies = {
            "p00f/nvim-ts-rainbow",
            "m-demare/hlargs.nvim",
        },
    },
}
