return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- LSP for neovim, must be loaded before lspconfig
            { "folke/neodev.nvim", config = true },
            {
                "mason-org/mason-lspconfig.nvim",
                -- match after/plugin/lsp.lua
                opts = {
                    ensure_installed = {
                        "bashls",
                        "clangd",
                        "cssls",
                        "gopls",
                        -- "html",
                        "jedi_language_server",
                        "lua_ls",
                        "marksman",
                        "nil_ls",
                        "rust_analyzer",
                        "sqls",
                        "texlab",
                        "vtsls",
                        "zls",
                    },
                    automatic_enable = false,
                },
                dependencies = {
                    { "mason-org/mason.nvim", config = true },
                },
            },
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
                dependencies = "ratakor/vim-snippets",
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
