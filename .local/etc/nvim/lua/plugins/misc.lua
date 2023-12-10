return {
    -- Status bar
    "nvim-lualine/lualine.nvim",
    dependencies = {
        { "kyazdani42/nvim-web-devicons", setup = true },
    },

    -- Starting screen
    "mhinz/vim-startify",

    -- gc/gcc magic comment
    { "numToStr/Comment.nvim", config = true },

    -- FixWhitespace
    "bronson/vim-trailing-whitespace",

    -- HUD for git in vim
    "airblade/vim-gitgutter",

    -- git in vim
    --"tpope/vim-fugitive",

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

    -- History visualizer
    "mbbill/undotree",

    {
        "github/copilot.vim",
        enabled = false,
    },

    -- Put a print statement with g?p or g?v
    { "andrewferrier/debugprint.nvim", setup = true },

    -- Testing inside vim
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "lawrence-laz/neotest-zig",
        },
    },

    -- TODO: switch to chadtree?
    "preservim/nerdtree",

    "tpope/vim-abolish",
    "ziglang/zig.vim",
    "petertriho/nvim-scrollbar",

    -- Debugger (TODO + not in misc)
    --"mfussenegger/nvim-dap",
}
