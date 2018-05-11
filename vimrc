" Begin .vimrc

execute pathogen#infect()

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Set background to dark so color scheme is properly set
set background=dark

" Set color scheme
colorscheme aschema

" Enable syntax highlighting
syntax on

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Display line numbers on the left
set number

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype plugin indent on

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab

" Enable use of the mouse for all modes
set mouse=a

" Disable text wrap
set nowrap

" Disable auto comment insert
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Map Nerdtree toggle
map <C-n> :NERDTreeToggle<CR>

" Map CtrlP
map <C-p> :CtrlP<CR>

" Set encoding
set encoding=utf-8

" End .vimrc
