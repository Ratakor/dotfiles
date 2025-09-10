return {
    "gruvbox.nvim",
    priority = 1000,
    after = function()
        require("gruvbox").setup({
            italic = {
                strings = false,
                comments = false,
            },
            transparent_mode = true,
        })
    end,
}
