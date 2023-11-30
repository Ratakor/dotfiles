" Automatic vim-plug installation
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
" Appearance
Plug 'Mofiqul/dracula.nvim' " dracula theme
Plug 'ellisonleao/gruvbox.nvim' " gruvbox theme
Plug 'mhinz/vim-startify' " start screen
Plug 'nvim-lualine/lualine.nvim' " bottom bar
Plug 'kyazdani42/nvim-web-devicons' " fancy icons
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " syntax color
Plug 'p00f/nvim-ts-rainbow' " funny brackets
"Plug 'lukas-reineke/indent-blankline.nvim' " funny indentation
Plug 'm-demare/hlargs.nvim' " highlight arguments

" LSP, Autocompletion Engine and Snippets
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
"Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-calc'
Plug 'ray-x/cmp-treesitter'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip', {'do': 'make install_jsregexp'}
Plug 'ratakor/vim-snippets'

" Misc
Plug 'bronson/vim-trailing-whitespace' " FixWhitespace
Plug 'airblade/vim-gitgutter' " hud for git in vim
Plug 'nvim-lua/plenary.nvim' " dependency for telescope and neotest
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' } " fuzzy finder
Plug 'antoinemadec/FixCursorHold.nvim' " dependency for neotest
Plug 'nvim-neotest/neotest'
Plug 'lawrence-laz/neotest-zig'
Plug 'preservim/nerdtree' " vs code be like
Plug 'mbbill/undotree' " history visualizer
Plug 'tpope/vim-commentary' " gc/gcc magic comment
Plug 'tpope/vim-abolish'
"Plug 'tpope/vim-fugitive' " git in vim
Plug 'ziglang/zig.vim'
Plug 'kovetskiy/sxhkd-vim'
Plug 'petertriho/nvim-scrollbar'
Plug 'andrewferrier/debugprint.nvim'
"Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
"Plug 'mfussenegger/nvim-dap'
call plug#end()

source $XDG_CONFIG_HOME/nvim/basics.vim
"source $XDG_CONFIG_HOME/nvim/header.vim
source $XDG_CONFIG_HOME/nvim/appearance.vim
source $XDG_CONFIG_HOME/nvim/lsp.vim

" Telescope config
nnoremap <C-S> :Telescope find_files<CR>
nnoremap <C-G> :Telescope git_files<CR>

" NerdTree config
nnoremap <F2> :NERDTreeToggle<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Undotree config
nnoremap <F3> :UndotreeToggle<CR>

autocmd BufWritePost * GitGutter

" custom vim-commentary
autocmd FileType zig setl commentstring=//\ %s
autocmd FileType cs setl commentstring=/*\ %s\ */

lua << EOF
-- g?p or g?v
require("debugprint").setup()

require("neotest").setup({
	adapters = {
		require("neotest-zig"),
	},
	summary = {
		enabled = true,
		animated = true,
		follow = true,
		expand_error = true,

		mappings = {
			expand = { "<CR>", "<2-LeftMouse>" },
			expand_all = "e",
			output = "o",
			short = "O",
			attach = "a",
			jumpto = { "i", "<C-]>" },
			stop = "u",
			run = "r",
			debug = "d",
			mark = "m",
			run_marked = "R",
			debug_marked = "D",
			clear_marked = "M",
			target = "t",
			clear_target = "T",
			next_failed = "J",
			prev_failed = "K",
		},
	},
})

vim.keymap.set("n", "<C-t>", function()
	-- require("neotest").run.run()
	require("neotest").summary.toggle()
	local win = vim.fn.bufwinid("Neotest Summary")
	if win > -1 then
		vim.api.nvim_set_current_win(win)
	end
end)
EOF

let g:startify_custom_header = [
	\"   ▄▄▄   ▄▄▄· ▄▄▄▄▄ ▄▄▄· ▄ •▄       ▄▄▄  ",
	\"   ▀▄ █·▐█ ▀█ •██  ▐█ ▀█ █▌▄▌▪▪     ▀▄ █·",
	\"   ▐▀▀▄ ▄█▀▀█  ▐█.▪▄█▀▀█ ▐▀▀▄· ▄█▀▄ ▐▀▀▄ ",
	\"   ▐█•█▌▐█ ▪▐▌ ▐█▌·▐█ ▪▐▌▐█.█▌▐█▌.▐▌▐█•█▌",
	\"   .▀  ▀ ▀  ▀  ▀▀▀  ▀  ▀ ·▀  ▀ ▀█▄▀▪.▀  ▀",
	\]
