return {
    -- Starting screen
    {
        "vim-startify",
        beforeAll = function()
            vim.g.startify_custom_header = {
                "   ▄▄▄   ▄▄▄· ▄▄▄▄▄ ▄▄▄· ▄ •▄       ▄▄▄  ",
                "   ▀▄ █·▐█ ▀█ •██  ▐█ ▀█ █▌▄▌▪▪     ▀▄ █·",
                "   ▐▀▀▄ ▄█▀▀█  ▐█.▪▄█▀▀█ ▐▀▀▄· ▄█▀▄ ▐▀▀▄ ",
                "   ▐█•█▌▐█ ▪▐▌ ▐█▌·▐█ ▪▐▌▐█.█▌▐█▌.▐▌▐█•█▌",
                "   .▀  ▀ ▀  ▀  ▀▀▀  ▀  ▀ ·▀  ▀ ▀█▄▀▪.▀  ▀",
            }
        end,
    },

    -- gc/gcc magic comment
    {
        "comment.nvim",
        after = function()
            require("Comment").setup({ ignore = "^$" })

            local ft = require("Comment.ft")
            ft.set("c", { "/*%s*/", "//%s" })
            ft.set("nov", { ";%s" })
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

    -- History visualizer
    {
        "undotree",
        keys = {
            { "<F3>", "<CMD>UndotreeToggle<CR>", desc = "Toggle UndoTree" },
        },
    },

    -- Evil AI
    -- TODO: cpuburn when no internet
    {
        "copilot.lua",
        enabled = false,
        -- build = ":Copilot auth",
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

    {
        "which-key.nvim",
        event = "DeferredUIEnter", -- VeryLazy
        beforeAll = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 300
        end,
        after = function()
            require("which-key").setup({})
        end,
    },

    -- TODO: switch to chadtree or neo-tree?
    {
        "nerdtree",
        keys = {
            { "<F2>", "<CMD>NERDTreeToggle<CR>", desc = "Toggle NERDTree" },
        },
        after = function()
            vim.cmd(
                "autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif"
            )
        end,
    },

    { "vim-abolish" },
    {
        "zig.vim",
        beforeAll = function()
            -- Disable auto-format on save for zig, too slow
            vim.g.zig_fmt_autosave = 0
        end,
    },

    {
        "vimtex",
        lazy = false,
        beforeAll = function()
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
    -- local strudel = require("strudel")
    -- vim.keymap.set("n", "<leader>sl", strudel.launch, { desc = "Launch Strudel" })
    -- vim.keymap.set("n", "<leader>sq", strudel.quit, { desc = "Quit Strudel" })
    -- vim.keymap.set("n", "<leader>st", strudel.toggle, { desc = "Strudel Toggle Play/Stop" })
    -- vim.keymap.set("n", "<leader>su", strudel.update, { desc = "Strudel Update" })
    -- vim.keymap.set("n", "<leader>ss", strudel.stop, { desc = "Strudel Stop Playback" })
    -- vim.keymap.set("n", "<leader>sb", strudel.set_buffer, { desc = "Strudel set current buffer" })
    -- vim.keymap.set("n", "<leader>sx", strudel.execute, { desc = "Strudel set current buffer and update" })

    {
        "comfy-line-numbers.nvim",
        after = function()
            require("comfy-line-numbers").setup({
                hidden_file_types = {
                    "undotree",
                    -- "NERD_tree",
                    "",
                },
            })
        end,
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
