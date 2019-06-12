" map the leader before using it in plugin key combos
let mapleader=","

" *****************************************************************************
" BEGIN PLUG STUFF
call plug#begin('~/.local/share/nvim/plugged')

Plug 'airblade/vim-gitgutter'
" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'kien/ctrlp.vim'
Plug 'mileszs/ack.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'easymotion/vim-easymotion'
Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-unimpaired'
Plug 'chrisbra/histwin.vim'
Plug 'amperser/proselint', {'rtp': 'plugins/vim/syntastic_proselint/'}
Plug 'Yggdroot/indentLine'
Plug 'elixir-lang/vim-elixir'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'vim-scripts/closetag.vim'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'

call plug#end()
" END PLUG STUFF

" BEGIN PLUGIN DESCRIPTIONS
" *****************************************************************************
" vim-gitgutter
" keymap for moving in hunks
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

" handle grep alias (for color auto)
let g:gitgutter_escape_grep = 1
" *****************************************************************************
" NERDTree
" open/close with Ctrl-e
map <C-e> :NERDTreeToggle<CR>

" open NERDTree when starting vim without a file
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" close vim if the only open window is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" when opening a file, close NERDTree
let NERDTreeQuitOnOpen = 0
" *****************************************************************************
" vim-buffergator
" browse through buffers with NERDTree like interface
" open with Ctrl-b
map <C-b> :BuffergatorToggle<CR>
" *****************************************************************************
" ctrlp
" use ctrlp to search for filenames
"
" use ripgrep
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif
" *****************************************************************************
" ack
" search all files for pattern
" :Ack [options] {pattern} [{directories}]
"
let g:ackprg = 'rg --vimgrep --smart-case'

cnoreabbrev rg Ack
cnoreabbrev rG Ack
cnoreabbrev Rg Ack
cnoreabbrev RG Ack
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack
" *****************************************************************************
" splitjoin
" gS to split a one line if statement into multiline
" gJ it join a multiline if statement into one line
" *****************************************************************************
" vim-easymotion
" use ,<motion> instead of ,,<motion>
map <Leader> <Plug>(easymotion-prefix)
" *****************************************************************************
" vim-airline
" use powerline font
let g:airline_powerline_fonts = 1
" only show the swanky mode indicator
set noshowmode
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" Skip the version control bit (I do this with zsh / bash)
let g:airline_section_b = ''
" Skip the file information because it uses too many characters
let g:airline_section_x = ''
let g:airline_section_y = ''
" Don't draw all these things I just disabled
let g:airline_skip_empty_sections = 1
" *****************************************************************************
" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 3
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_rake_checkers = ['rubocop']
let g:syntastic_markdown_checkers = ['proselint']
let g:syntastic_tex_checkers = ['proselint']
let g:syntastic_text_checkers = ['proselint']
" the sqlint doesn't seem to work very well :(
let g:syntastic_sql_checkers = []
" *****************************************************************************
" vim-unimpaired
" *****************************************************************************
" gist-vim
" set gists to private by default
let g:gist_post_private = 1

" *****************************************************************************
" histwin
" *****************************************************************************
" use leader u to open history browser
nnoremap <leader>u :Histwin<CR>
" *****************************************************************************
" indent guides
" *****************************************************************************
" guide character
let g:indentLine_char = '.'
let g:indentLine_color_term = 239
" *****************************************************************************
" vim-gutentags
" *****************************************************************************
" majutsushi/tagbar
nmap <C-t> :TagbarToggle<CR>
" *****************************************************************************
" END PLUGIN DESCRIPTIONS

" load filetype-specific indent files
filetype indent on

" With a map leader it's possible to do extra key combinations
let mapleader=","
" one second timeout for leader+key combos
set timeout timeoutlen=1000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" number lines
set number

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

" Show last command in bottom right corner
set showcmd

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" clear search highlighting
nnoremap <leader>c :nohlsearch<CR>

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
"
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable
set background=dark

" Don't hide characters in LaTeX
let g:tex_fast= ""

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Show a highlighted color bar at 100 characters
set colorcolumn=100
hi ColorColumn ctermbg=darkgrey guibg=darkgrey
set textwidth=100
" Or 80 in a ruby file
autocmd BufRead,BufNewFile *.rb set colorcolumn=80
autocmd BufRead,BufNewFile *.rb set textwidth=80
" and 72 in a gitcommmit
autocmd FileType gitcommit set colorcolumn=72
autocmd FileType gitcommit set textwidth=72

" Use Q to wrap lines over a motion
nnoremap Q gq

" Show trailing whitespaces
set list listchars=tab:»\ ,trail:•,extends:›,precedes:‹,nbsp:•

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set backupdir=~/.vim/backup,/tmp
set directory=~/.vim/backup,/tmp
set undodir=~/.vim/backup,/tmp

" turn on persistent undo
set undofile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" load filetype-specific indent files
filetype indent on

" Use spaces instead of tabs
set expandtab
" Except in HTML and JS
au BufRead,BufNewFile *.html*,*js set noexpandtab
" And C
au BufRead,BufNewFile *.c,*h set noexpandtab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
" except in py and php files
au BufRead,BufNewFile *.py,*pyw set shiftwidth=4 tabstop=4
au Filetype php set shiftwidth=4 tabstop=4

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Delete trailing white space with ,,w
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
map <leader><leader>w :call DeleteTrailingWS()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

autocmd FileType gitcommit setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell
autocmd BufRead,BufNewFile *.md  setlocal spell
autocmd BufRead,BufNewFile *.tex setlocal spell

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" preload the p yank buffer with binding.pry line
map <leader>pry Orequire 'pry'; binding.pry<esc>j
map <leader>pdb Oimport pdb; pdb.set_trace()<esc>j

map <leader>nonp /\(\p\\|$\)\@!.<esc>
if !has('nvim')
  set clipboard=unnamed
else
  set clipboard+=unnamedplus
endif

" Edit crontab files on OSX
autocmd filetype crontab setlocal nobackup nowritebackup

" Uppercase SQL keywords. See https://groups.google.com/d/msg/vim_use/k-evBSOrNQM/PRZaLxsT1ksJ
map <leader>sql :%s/\<\w\+\>/\=synIDattr(synID(line('.'),col('.'),1), 'name')=~'sql\%(keyword\|operator\|statement\)'?toupper(submatch(0)):submatch(0)/g

" Incremental command feedback
set inccommand=nosplit

" copy current file name (relative/absolute) to system clipboard
if has("mac") || has("gui_macvim") || has("gui_mac")
  " relative path  (src/foo.txt)
  nnoremap <leader>cf :let @*=expand("%")<CR>

  " absolute path  (/something/src/foo.txt)
  nnoremap <leader>cF :let @*=expand("%:p")<CR>

  " filename       (foo.txt)
  nnoremap <leader>ct :let @*=expand("%:t")<CR>

  " directory name (/something/src)
  nnoremap <leader>ch :let @*=expand("%:p:h")<CR>
endif

" copy current file name (relative/absolute) to system clipboard (Linux version)
if has("gui_gtk") || has("gui_gtk2") || has("gui_gnome") || has("unix")
  " relative path (src/foo.txt)
  nnoremap <leader>cf :let @+=expand("%")<CR>

  " absolute path (/something/src/foo.txt)
  nnoremap <leader>cF :let @+=expand("%:p")<CR>

  " filename (foo.txt)
  nnoremap <leader>ct :let @+=expand("%:t")<CR>

  " directory name (/something/src)
  nnoremap <leader>ch :let @+=expand("%:p:h")<CR>
endif

  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif

syntax on
colorscheme onedark
