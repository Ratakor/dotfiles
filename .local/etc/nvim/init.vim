" Automatic vim-plug installation
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'Mofiqul/dracula.nvim' " dracula theme
Plug 'mhinz/vim-startify' " start screen
Plug 'bronson/vim-trailing-whitespace' " FixWhitespace
Plug 'airblade/vim-gitgutter' " hud for git in vim
"Plug 'tpope/vim-fugitive' " git in vim
Plug 'nvim-lua/plenary.nvim' " dependency for telescope
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' } " fuzzy finder
Plug 'nvim-lualine/lualine.nvim' " bottom bar
Plug 'kyazdani42/nvim-web-devicons' "fancy icons
Plug 'preservim/nerdtree' " vs code be like
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Auto-Completion
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " syntax color
Plug 'p00f/nvim-ts-rainbow' " funny brackets
"Plug 'puremourning/vimspector' " Debugger

"" C#
"Plug 'OmniSharp/omnisharp-vim'
"" Mappings, code-actions available flag and statusline integration
"Plug 'nickspoons/vim-sharpenup'
"" Linting/error highlighting
"Plug 'dense-analysis/ale'
"" Vim FZF integration, used as OmniSharp selector
"Plug 'junegunn/fzf'
"Plug 'junegunn/fzf.vim'
"" Autocompletion
"Plug 'prabirshrestha/asyncomplete.vim'
"" Colorscheme
"Plug 'gruvbox-community/gruvbox'
"" Statusline
"Plug 'itchyny/lightline.vim'
"Plug 'shinchu/lightline-gruvbox.vim'
"Plug 'maximbaz/lightline-ale'
"" Snippet support
"Plug 'sirver/ultisnips'
call plug#end()

source $XDG_CONFIG_HOME/nvim/basics.vim
source $XDG_CONFIG_HOME/nvim/lua.vim
source $XDG_CONFIG_HOME/nvim/coc.vim
"autocmd FileType cs source $XDG_CONFIG_HOME/nvim/cs.vim

" vimspector config
"let g:vimspector_enable_mappings = 'HUMAN'

" Open Telescope with <C-S>
nnoremap <C-S> :Telescope find_files<CR>

" Open NERDTree with <C-N>
nnoremap <C-N> :NERDTreeToggle<CR>
