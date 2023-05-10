" Set this to 1 to use ultisnips for snippet handling
let s:using_snippets = 0

" vim-plug: {{{
call plug#begin('~/.vim/plugged')

" Vim FZF integration
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" NERDTree
Plug 'preservim/nerdtree'

" Multi cursor
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax
Plug 'styled-components/vim-styled-components'
Plug 'prisma/vim-prisma'
Plug 'hashivim/vim-terraform'

" coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Colorscheme
Plug 'gruvbox-community/gruvbox'

" Statusline
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'

" Snippet support
if s:using_snippets
  Plug 'sirver/ultisnips'
endif

call plug#end()
" }}}

" Settings: {{{
filetype indent plugin on
if !exists('g:syntax_on') | syntax enable | endif
set encoding=utf-8
scriptencoding utf-8

set autoindent
set cindent
set smartindent

set backspace=indent,eol,start
set expandtab
set shiftround
set shiftwidth=2
set softtabstop=2
set tabstop=2
set textwidth=160
set title
set nowrap

set hidden
set nofixendofline
set nostartofline
set number
set splitbelow
set splitright
set ignorecase

set nobackup
set nowritebackup
set noswapfile

set hlsearch
set incsearch
set laststatus=2
set noruler
set noshowmode
set signcolumn=yes

set mouse=a
set updatetime=1000
" }}}

" Colors: {{{
augroup ColorschemePreferences
  autocmd!
  " These preferences clear some gruvbox background colours, allowing transparency
  autocmd ColorScheme * highlight Normal     ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight SignColumn ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight Todo       ctermbg=NONE guibg=NONE
augroup END

" Use truecolor in the terminal, when it is supported
if has('termguicolors')
  set termguicolors
endif

set background=dark
colorscheme gruvbox
" }}}

" Lightline: {{{
let g:lightline = {
\ 'colorscheme': 'gruvbox',
\ 'active': {
\   'right': [
\     ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
\     ['lineinfo'], ['percent'],
\     ['fileformat', 'fileencoding', 'filetype']
\   ]
\ },
\ 'inactive': {
\   'right': [['lineinfo'], ['percent']]
\ },
  \ 'component_type': {
  \   'linter_checking': 'right',
  \   'linter_infos': 'right',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_ok': 'right'
\  }
\}

set mouse=
set ttymouse=
set term=xterm-256color
set scrolloff=999

let g:NERDTreeWinSize=120
let g:NERDTreeQuitOnOpen = 1

map <C-t> :NERDTreeFind<CR>

map <C-p> :Files<CR>

let g:coc_global_extensions = ['coc-json', 'coc-tsserver']

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

set noerrorbells visualbell t_vb=

command AutoSave autocmd TextChanged,TextChangedI <buffer> silent write

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> qf <Plug>(coc-fix-current)
nmap <silent> ca <Plug>(coc-codeaction)
nmap <silent> ci <Plug>(coc-diagnostic-info)
nmap <C-Left> b
nmap <C-Right> w

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

