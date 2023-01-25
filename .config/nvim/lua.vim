lua << END
require'lualine'.setup {
  options = {
    theme = 'dracula-nvim', --'gruvbox',
  }
}

require'nvim-web-devicons'.setup {}

require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		--disable = {"c_sharp"},
	},

	rainbow = {
		enable = true,
		extended_mode = false,
		--disable = {"c_sharp"},
	}
}

require'dracula'.setup {
	show_end_of_buffer = true,
	lualine_bg_color = "#44475a",
	transparent_bg = true,
}
END
