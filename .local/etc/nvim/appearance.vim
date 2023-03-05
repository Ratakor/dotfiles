if has('termguicolors')
	set termguicolors
endif
colorscheme dracula

lua << EOF
--require("dracula").setup {
--	show_end_of_buffer = true,
--	lualine_bg_color = "#44475a",
--	transparent_bg = true,
--}

require("lualine").setup {
  options = { theme = ("dracula-nvim"), }
}

require("nvim-web-devicons").setup {}

require("nvim-treesitter.configs").setup {
	ensure_installed = {
		"bash", "c", "c_sharp", "comment", "css", "diff", "git_rebase",
		"gitattributes", "gitcommit", "gitignore", "help", "html",
		"latex", "lua", "make", "markdown", "python", "rust", "vim"
	},

	highlight = {
		enable = true,
		--disable = { "c_sharp" },
	},

	additional_vim_regex_highlighting = false,

	rainbow = {
		enable = true,
		extended_mode = true,
	}
}
EOF
