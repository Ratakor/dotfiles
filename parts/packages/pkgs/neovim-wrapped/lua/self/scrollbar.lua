local colors = require("gruvbox").palette

require("scrollbar").setup({
  marks = {
    Search = { color = colors.neutral_orange },
    Error = { color = colors.neutral_red },
    Warn = { color = colors.neutral_yellow },
    Info = { color = colors.neutral_purple },
    Hint = { color = colors.neutral_aqua },
    Misc = { color = colors.neutral_purple },
  },
  handlers = {
    cursor = false,
    handle = false,
  },
})
