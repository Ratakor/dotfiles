require("self.lazy").add_specs({
  {
    "noice.nvim",
    event = "DeferredUIEnter",
    after = function()
      -- Only set this if nui.nvim is lazy loaded (in opt/)
      -- require("self.lazy").packadd("nui.nvim")

      require("self.lazy").packadd("nvim-notify")
      require("notify").setup({
        background_colour = "#000000",
      })

      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              kind = "",
            },
            opts = { skip = true },
          },
        },
      })
    end,
  },
})
