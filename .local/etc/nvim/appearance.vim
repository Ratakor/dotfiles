lua << EOF
local colors = require('gruvbox.palette').colors

require("dracula").setup {
	show_end_of_buffer = true,
	lualine_bg_color = "#44475a",
	transparent_bg = true,
}

require("gruvbox").setup {
	italic = {
		strings = false,
	},
	transparent_mode = true,
}

--require("catppuccin").setup({
--    flavour = "macchiato",
--    transparent_background = true,
--    show_end_of_buffer = true,
--})
--
--require("everforest").setup({
--	transparent_background_level = 1,
--})

local empty = require('lualine.component'):extend()
function empty:draw(default_highlight)
	self.status = ''
	self.applied_separator = ''
	self:apply_highlights(default_highlight)
	self:apply_section_separators()
	return self.status
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
	for name, section in pairs(sections) do
		local left = name:sub(9, 10) < 'x'
		for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
			table.insert(section, pos * 2, { empty, color = { fg = colors.neutral_white, bg = colors.neutral_white } })
		end
		for id, comp in ipairs(section) do
			if type(comp) ~= 'table' then
				comp = { comp }
				section[id] = comp
			end
			comp.separator = left and { right = '' } or { left = '' }
		end
	end
	return sections
end

local function modified()
	if vim.bo.modified then
		return '+'
	elseif vim.bo.modifiable == false or vim.bo.readonly == true then
		return '-'
	end
	return ''
end

local transparent = require'lualine.themes.gruvbox'
transparent.inactive.c.bg = 'nil'
transparent.visual.c.bg = 'nil'
transparent.replace.c.bg = 'nil'
transparent.normal.c.bg = 'nil'
transparent.insert.c.bg = 'nil'
transparent.command.c.bg = 'nil'

require('lualine').setup {
	options = {
		theme = transparent,
		component_separators = '',
		section_separators = { left = '', right = '' },
	},
	sections = process_sections {
		lualine_a = { 'mode' },
		lualine_b = {
			'branch',
			'diff',
			{ 'filename', file_status = false, path = 1 },
			{
				'diagnostics',
				source = { 'nvim' },
				sections = { 'error' },
				symbols = {error = 'E '},
				diagnostics_color = { error = { bg = colors.neutral_red, fg = colors.dark0, gui = 'bold' } },
				--on_click = function()
				--	vim.diagnostic.goto_prev()
				--	end
			},
			{
				'diagnostics',
				source = { 'nvim' },
				sections = { 'warn' },
				symbols = {warn = 'W '},
				diagnostics_color = { warn = { bg = colors.neutral_orange, fg = colors.dark0, gui = 'bold' } },
				--on_click = function()
				--	vim.diagnostic.goto_next()
				--	end
			},
			{ modified, color = { bg = colors.neutral_purple } },
			{
				'%w',
				cond = function()
					return vim.wo.previewwindow
				end,
			},
			{
				'%r',
				cond = function()
					return vim.bo.readonly
				end,
			},
			{
				'%q',
				cond = function()
					return vim.bo.buftype == 'quickfix'
				end,
			},
		},
		lualine_c = {},
		lualine_x = { 'fileformat' },
		lualine_y = { 'filetype', 'progress' },
		lualine_z = { 'location' },
	},
}

require('hlargs').setup {
	color = colors.neutral_orange
}

require("scrollbar").setup({
	marks = {
		Search = { color = colors.neutral_orange },
		Error = { color = colors.neutral_red },
		Warn = { color = colors.neutral_yellow },
		Info = { color = colors.neutral_pink },
		Hint = { color = colors.neutral_cyan },
		Misc = { color = colors.neutral_purple },
	},
	handlers = {
		cursor = false,
	handle = false,
	},
})

--vim.cmd [[highlight IndentBlanklineIndent1 guifg=#bd93f9 gui=nocombine]]
--vim.cmd [[highlight IndentBlanklineIndent2 guifg=#50fa7b gui=nocombine]]
--vim.cmd [[highlight IndentBlanklineIndent3 guifg=#8be9fd gui=nocombine]]
--vim.cmd [[highlight IndentBlanklineIndent4 guifg=#f1fa8c gui=nocombine]]
--vim.cmd [[highlight IndentBlanklineIndent5 guifg=#ffb86c gui=nocombine]]
--vim.cmd [[highlight IndentBlanklineIndent6 guifg=#ff5555 gui=nocombine]]
--
--require("indent_blankline").setup {
--	space_char_blankline = " ",
--
--	--show_current_context = true,
--	--show_current_context_start = true,
--
--	char_highlight_list = {
--		"IndentBlanklineIndent1",
--		"IndentBlanklineIndent2",
--		"IndentBlanklineIndent3",
--		"IndentBlanklineIndent4",
--		"IndentBlanklineIndent5",
--		"IndentBlanklineIndent6",
--	},
--}

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
		enable = true,
		extended_mode = true,
	}
}
EOF

set background=dark
colorscheme gruvbox
