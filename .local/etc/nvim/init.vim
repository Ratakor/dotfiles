" Automatic vim-plug installation
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
" Appearance
Plug 'Ratakor/dracula.nvim' " dracula theme
Plug 'mhinz/vim-startify' " start screen
Plug 'nvim-lualine/lualine.nvim' " bottom bar
Plug 'kyazdani42/nvim-web-devicons' " fancy icons
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " syntax color
Plug 'p00f/nvim-ts-rainbow' " funny brackets
" LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
" Autocompletion Engine
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-calc'
Plug 'ray-x/cmp-treesitter'
Plug 'saadparwaiz1/cmp_luasnip'
"  Snippets
Plug 'L3MON4D3/LuaSnip', {'do': 'make install_jsregexp'}
Plug 'honza/vim-snippets'
" Misc
Plug 'bronson/vim-trailing-whitespace' " FixWhitespace
Plug 'airblade/vim-gitgutter' " hud for git in vim
Plug 'nvim-lua/plenary.nvim' " dependency for telescope
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' } " fuzzy finder
Plug 'preservim/nerdtree' " vs code be like
Plug 'mbbill/undotree' " history visualizer
Plug 'tpope/vim-commentary' " gc/gcc magic comment
Plug 'ziglang/zig.vim'
call plug#end()

source $XDG_CONFIG_HOME/nvim/basics.vim
source $XDG_CONFIG_HOME/nvim/appearance.vim
source $XDG_CONFIG_HOME/nvim/lsp.vim

" Telescope config
nnoremap <C-S> :Telescope find_files<CR>
nnoremap <C-G> :Telescope git_files<CR>

" NerdTree config
nnoremap <F2> :NERDTreeToggle<CR>

" Undotree config
nnoremap <F3> :UndotreeToggle<CR>

" vim-commentary for zig
autocmd FileType zig setlocal commentstring=//\ %s
