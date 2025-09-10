return {
    -- Status bar
    {
        "lualine.nvim",
        dependencies = {
            {
                "nvim-web-devicons",
                config = true,
            },
        },
    },

    -- Starting screen
    { "vim-startify" },

    -- gc/gcc magic comment
    {
        "comment.nvim",
        after = function()
            require("Comment").setup({ ignore = "^$" })
        end,
    },

    -- FixWhitespace
    { "vim-trailing-whitespace" },

    -- HUD for git in vim
    {
        "gitsigns.nvim",
        after = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked = { text = "" },
                },
            })
        end,
    },

    -- git in vim
    --"vim-fugitive",
    --"vim-rhubarb",

    -- Fuzzy finder
    {
        "telescope.nvim",
        dependencies = {
            "plenary.nvim",
            -- {
            --     "nvim-telescope/telescope-fzf-native.nvim",
            --     build = "make",
            --     config = function()
            --         require("telescope").load_extension("fzf")
            --     end,
            -- },
        },
    },

    -- History visualizer
    { "undotree" },

    -- Evil AI
    -- TODO: cpuburn when no internet
    {
        "copilot.lua",
        enabled = false,
        build = ":Copilot auth",
        after = function()
            require("copilot").setup({
                panel = { enabled = false },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept = "<C-h>",
                        dismiss = "<C-l>",
                    },
                },
            })
        end,
    },

    -- Testing inside vim
    -- {
    --     "neotest",
    --     dependencies = {
    --         "nvim-nio",
    --         "plenary-nvim",
    --         "FixCursorHold-nvim",
    --         "neotest-zig",
    --     },
    -- },

    {
        "which-key.nvim",
        event = "DeferredUIEnter", -- VeryLazy
        after = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 300
            require("which-key").setup({})
        end,
    },

    -- TODO: switch to chadtree?
    { "nerdtree" },

    { "vim-abolish" },
    { "zig.vim" },
    { "nvim-scrollbar" },

    {
        "vimtex",
        lazy = false,
        init = function()
            vim.g.vimtex_view_method = "zathura"
        end,
    },

    -- FIXME
    -- {
    --     "gruvw/strudel.nvim",
    --     cmd = "StrudelLaunch",
    --     build = "npm install",
    --     config = function()
    --         require("strudel").setup({
    --             update_on_save = true,
    --             -- headless = true,
    --             browser_data_dir = (os.getenv("XDG_CACHE_HOME") or "~/.cache") .. "/strudel-nvim",
    --         })
    --     end,
    -- },

    {
        "comfy-line-numbers.nvim",
        opts = {
            hidden_file_types = {
                "undotree",
                -- "NERD_tree",
                "",
            },
        },
    },

    -- {
    --     "NotAShelf/syntax-gaslighting.nvim",
    --     enabled = false,
    --     config = function()
    --         vim.api.nvim_set_hl(0, "GaslightingUnderline", { fg = "#d79921" })
    --         require("syntax-gaslighting").setup({})
    --     end,
    -- },
}
