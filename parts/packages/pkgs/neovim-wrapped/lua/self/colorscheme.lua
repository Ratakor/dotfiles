require("gruvbox").setup({
  italic = {
    strings = false,
    comments = false,
  },
  transparent_mode = true,
})

vim.opt.background = "dark"
vim.cmd("colorscheme gruvbox")
