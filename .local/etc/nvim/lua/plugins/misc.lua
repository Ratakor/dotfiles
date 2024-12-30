return {
    -- Status bar
    "nvim-lualine/lualine.nvim",
    dependencies = {
        { "kyazdani42/nvim-web-devicons", config = true },
    },

    -- Starting screen
    "mhinz/vim-startify",

    -- gc/gcc magic comment
    {
        "numToStr/Comment.nvim",
        opts = { ignore = "^$" },
    },

    -- FixWhitespace
    "bronson/vim-trailing-whitespace",

    -- HUD for git in vim
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
                untracked = { text = '' },
            },
        },
    },

    -- git in vim
    --"tpope/vim-fugitive",
    --"tpope/vim-rhubarb",

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
        },
    },

    -- History visualizer
    "mbbill/undotree",

    -- Evil AI
    {
        "zbirenbaum/copilot.lua",
        enabled = true,
        build = ":Copilot auth",
        opts = {
            panel = { enabled = false },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<C-h>",
                    dismiss = "<C-l>",
                },
            },
        },
    },

    -- Testing inside vim
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "lawrence-laz/neotest-zig",
        },
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function ()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 300
        end,
        config = true,
    },

    -- TODO: switch to chadtree?
    "preservim/nerdtree",

    "tpope/vim-abolish",
    "ziglang/zig.vim",
    "petertriho/nvim-scrollbar",

    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            vim.g.vimtex_view_method = "zathura"
        end,
    },

    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
}
