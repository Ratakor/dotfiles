lua << EOF
require("dracula").setup {
	show_end_of_buffer = true,
	lualine_bg_color = "#44475a",
	transparent_bg = true,
}

require("lualine").setup {
  options = {
    theme = ("dracula-nvim"),
  }
}

require("nvim-web-devicons").setup {}

require("nvim-treesitter.configs").setup {
	ensure_installed = {
		"c", "vim", "help", "bash", "lua", "css", "html", "latex", "diff",
		"make",  "markdown", "ocaml", "python", "rust", "comment", "git_rebase",
		"gitattributes", "gitignore", "gitcommit", "json"
	},

	auto_install = true,

	highlight = {
		enable = true,
		--disable = { "c_sharp" },
	},

	rainbow = {
		enable = true,
		extended_mode = false,
	}
}
EOF
