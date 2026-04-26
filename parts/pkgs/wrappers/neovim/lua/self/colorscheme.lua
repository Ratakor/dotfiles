require("gruvbox").setup({
  italic = {
    strings = false,
    comments = false,
  },
  transparent_mode = true,
})

vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")
