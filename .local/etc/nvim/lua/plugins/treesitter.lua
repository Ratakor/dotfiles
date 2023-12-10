return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
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
                    "latex",
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "regex",
                    "rust",
                    "scheme",
                    "vim",
                    "vimdoc",
                    "zig",
                },
                highlight = {
                    enable = true,
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
