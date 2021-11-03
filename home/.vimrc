" Vundle begin
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle/')

Bundle 'edkolev/promptline.vim'
Plugin 'VundleVim/Vundle.vim'
Plugin 'tmux-plugins/vim-tmux-focus-events'
Plugin 'vphantom/vim-obsession'
Plugin 'szczad/vim-colorschemes'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'Shougo/denite.nvim'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'martinda/Jenkinsfile-vim-syntax'
Plugin 'hashivim/vim-terraform'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'tpope/vim-commentary'
Plugin 'itspriddle/vim-shellcheck'
Plugin 'google/vim-jsonnet'
Plugin 'towolf/vim-helm'
Plugin 'will133/vim-dirdiff'
Plugin 'cespare/vim-toml'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'fatih/vim-go'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'ryanoasis/vim-devicons'

call vundle#end()
" Vundle end


" General options
filetype plugin indent on
syntax on
set list
set ruler
set showcmd
set showmode
set showtabline=2
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent smartindent
set laststatus=2
set hlsearch incsearch
set number
set directory=$HOME/.vim/swap//,./
set previewheight=20
set clipboard=unnamedplus
set colorcolumn=78
set nowrap
set completeopt=popup,longest,menuone
colorscheme Benokai

" Leader
let mapleader="."

" Mouse support
set mouse=a
set ttymouse=sgr
set mousemodel=popup_setpos

" Common key mapping
" - Line operations:
map <leader>lw :set wrap!<CR>
map <leader>lp :set paste!<CR>

" Popup tuning
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

let g:UltiSnipsExpandTrigger="<c-b>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Airline w/Powerline
let g:airline_powerline_fonts = 1
let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
let g:airline_skip_empty_sections = 1
let g:airline_theme = 'base16'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

" NERDTree
let g:WebDevIconsUnicodeGlyphDoubleWidth = 0
let g:webdevicons_conceal_nerdtree_brackets = 1

function! s:NERDTreeChangeDir(dir) abort
  if !empty(a:dir) && isdirectory(a:dir) && !exists("s:std_in")
    echom "Changing dir " . a:dir
    cd a:dir
    exe 'NERDTree'
  endif
endfunction

map <C-N> :NERDTreeFocus<CR>
map <C-N><C-N> :NERDTreeToggle<CR>
let g:NERDTreeWinSize=40
let NERDTreeShowHidden=1
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
autocmd VimEnter * call s:NERDTreeChangeDir(get(argv(), 0, ''))
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd VimLeave * NERDTreeClose

" NETRW
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15

" Terraform
let g:terraform_fmt_on_save=1

" Vim Fugitive
map <leader>gs :Git<CR>
map <leader>ga :Git add %<CR>
map <leader>gc :Git commit<CR>
map <leader>gca :Git commit --amend<CR>
map <leader>gce :Git commit --amend -C HEAD<CR>
map <leader>gp :Git push<CR>
map <leader>gpf :Git push --force<CR>
map <leader>gl :Git pull<CR>
map <leader>gll :Git log<CR>
map <leader>gd :Gvdiff<CR>
map <leader>gD :Ghdiff<CR>

" DirDiff settings
let g:DirDiffExcludes = ".git,*.exe,.*.swp,*~"
let g:DirDiffIgnore = "Id:,Revision:,Date:"
let g:DirDiffWindowSize = 30

" Custom mapping
noremap <F5> :edit<CR>
noremap <C-F> :Rg<CR>

" Filetype mapping
" YAML remapping
autocmd FileType yaml execute  ':silent! %s#^\t\+#\=repeat(" ", len(submatch(0))*' . &ts . ')'

" YCM
let g:ycm_register_as_syntastic_checker = 1 "default 1
let g:ycm_show_diagnostics_ui = 1 "default 1

"will put icons in Vim's gutter on lines that have a diagnostic set.
"Turning this off will also turn off the YcmErrorLine and YcmWarningLine
"highlighting
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 1
let g:ycm_always_populate_location_list = 1 "default 0
let g:ycm_open_loclist_on_ycm_diags = 1 "default 1

let g:ycm_complete_in_strings = 1 "default 1
let g:ycm_collect_identifiers_from_tags_files = 0 "default 0
let g:ycm_path_to_python_interpreter = '' "default ''

let g:ycm_server_use_vim_stdout = 0 "default 0 (logging to console)
let g:ycm_server_log_level = 'info' "default info

let g:ycm_confirm_extra_conf = 0

let g:ycm_goto_buffer_command = 'same-buffer' "[ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
let g:ycm_filetype_whitelist = { '*': 1 }
let g:ycm_key_invoke_completion = '<C-Space>'

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

" Recompile current file
map <F11> :YcmForceCompileAndDiagnostics <CR>
" Shortcuts for navigating to definitions using YouCompleteMe
map <leader>yd  :YcmCompleter GoToDefinitionElseDeclaration<CR>
" Open definition in new vertical split
map <leader>yds :vsp <CR>:exec("YcmCompleter GoToDefinitionElseDeclaration")<CR>
" Open definition in new tab
map <leader>ydt :tab split<CR>:exec("YcmCompleter GoToDefinitionElseDeclaration")<CR>
