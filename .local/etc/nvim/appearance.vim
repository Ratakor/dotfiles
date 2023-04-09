if has('termguicolors')
	set termguicolors
endif
colorscheme dracula

lua << EOF
local colors = require('dracula').colors()

--require("dracula").setup {
--	show_end_of_buffer = true,
--	lualine_bg_color = "#44475a",
--	transparent_bg = true,
--}

require("lualine").setup {
	options = { theme = ("dracula-nvim"), }
}

require('hlargs').setup {
	color = colors.orange
}

require("scrollbar").setup({
	marks = {
		Search = { color = colors.orange },
	Error = { color = colors.red },
		Warn = { color = colors.yellow },
		Info = { color = colors.pink },
		Hint = { color = colors.cyan },
		Misc = { color = colors.purple },
	},
	handlers = {
		cursor = false,
	handle = false,
	},
})

vim.cmd [[highlight IndentBlanklineIndent1 guifg=#bd93f9 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#50fa7b gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#8be9fd gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#f1fa8c gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#ffb86c gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#ff5555 gui=nocombine]]

require("indent_blankline").setup {
	space_char_blankline = " ",

	--show_current_context = true,
	--show_current_context_start = true,

	char_highlight_list = {
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
		"IndentBlanklineIndent3",
		"IndentBlanklineIndent4",
		"IndentBlanklineIndent5",
		"IndentBlanklineIndent6",
	},
}

require("nvim-web-devicons").setup {}

require("nvim-treesitter.configs").setup {
	ensure_installed = {
		"bash", "c", "c_sharp", "comment", "css", "diff", "git_rebase",
		"gitattributes", "gitcommit", "gitignore", "html", "latex",
		"lua", "make", "markdown", "python", "rust", "vim", "vimdoc",
		"zig"
	},

	highlight = {
		enable = true,
	},

	additional_vim_regex_highlighting = false,

	rainbow = {
		enable = false,
		extended_mode = true,
	}
}
EOF
