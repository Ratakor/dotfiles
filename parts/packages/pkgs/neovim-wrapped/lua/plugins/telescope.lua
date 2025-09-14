return {
    -- {
    --     "nvim-telescope/telescope-fzf-native.nvim",
    --     build = "make",
    --     config = function()
    --     require("telescope").load_extension("fzf")
    --     end,
    -- },
    {
        "telescope.nvim",
        cmd = "Telescope",
        before = function()
            LZN.trigger_load("plenary.nvim")
            -- LZN.trigger_load("telescope-fzf-native.nvim")
        end,
        after = function()
            local keymap = LZN.keymap({
                "telescope.nvim",
                cmd = "Telescope",
                after = function()
                    require("telescope").setup()
                end,
            })

            local telescope = require("telescope.builtin")
            keymap.set("n", "<leader>f", telescope.find_files, { desc = "Find files" })
            keymap.set("n", "<C-g>", telescope.git_files, { desc = "Find git files" })
        end,
        -- See https://github.com/Gerg-L/nvim-flake/blob/bb92db9fd46114588a2a547e54a1a1b0f7555a86/lua/lazy/fzf.lua
        -- keys = {
        --     {
        --         "<leader>f",
        --         function()
        --             telescope.find_files,
        --         end,
        --         desc = "Find files",
        --     },
        -- },
    },
}
