return {
    {
        "nui.nvim",
    },
    -- {
    --     "nvim-notify",
    -- },
    {
        "noice.nvim",
        event = "DeferredUIEnter", -- VeryLazy
        before = function()
            LZN.trigger_load("nui.nvim")
            LZN.trigger_load("nvim-notify")
        end,
        after = function()
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
}
