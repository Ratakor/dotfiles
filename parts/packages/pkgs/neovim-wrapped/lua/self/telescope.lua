require("telescope").load_extension("fzf")

local map = vim.keymap.set
local telescope = require("telescope.builtin")
map("n", "<leader>f", telescope.find_files, { desc = "Find files" })
map("n", "<C-g>", telescope.git_files)
