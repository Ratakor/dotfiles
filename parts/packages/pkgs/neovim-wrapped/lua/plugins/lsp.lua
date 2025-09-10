return {
    {
        "nvim-lspconfig",
        dependencies = {
            -- LSP for neovim, must be loaded before lspconfig
            { "neodev-nvim", config = true },
        },
    },
    {
        -- Autocompletion
        "nvim-cmp",
        dependencies = {
            -- Snippets
            {
                "luasnip",
                build = "make install_jsregexp",
                -- FIXME
                -- dependencies = "ratakor/vim-snippets",
            },

            "cmp-nvim-lsp",
            "cmp-nvim-lsp-signature-help",
            --"cmp-nvim-lsp-document-symbol",
            "cmp-buffer",
            "cmp-path",
            "cmp-calc",
            "cmp-treesitter",
            "cmp_luasnip",
        },
    },
}
