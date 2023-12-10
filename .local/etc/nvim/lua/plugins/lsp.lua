return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- LSP for neovim, must be loaded before lspconfig
            { "folke/neodev.nvim", setup = true },
        },
    },
    {
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- Snippets
            {
                "L3MON4D3/LuaSnip",
                build = "make install_jsregexp",
                dependencies = {
                    "ratakor/vim-snippets",
                },
            },

            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            --"hrsh7th/cmp-nvim-lsp-document-symbol",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-calc",
            "ray-x/cmp-treesitter",
            "saadparwaiz1/cmp_luasnip",
        },
    },
}
