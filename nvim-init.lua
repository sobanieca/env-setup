local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
    },
    config = function()
      require('barbecue').setup {
        theme = 'tokyonight'
      }
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require('lualine').setup {
	options = {
    	   theme = 'tokyonight'
        }
      }
    end
  },
  {
    "nvim-telescope/telescope.nvim", tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
	actions = {
	  open_file = {
	    quit_on_open = true,
	  }
	}
      }
    end,
  }
})

vim.cmd[[colorscheme tokyonight]]

vim.api.nvim_create_user_command('Lg', 'Telescope live_grep', {});
vim.keymap.set({ 'n', 'v', 'i' }, '<C-p>', '<Cmd>Telescope find_files<CR>');
vim.keymap.set({ 'n', 'v', 'i' }, '<C-t>', '<Cmd>NvimTreeFindFile<CR>');

vim.o.smartindent = true

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftround = true
vim.o.shiftwidth=2
vim.o.softtabstop=2
vim.o.textwidth=160

vim.o.title = true
vim.o.nowrap = true

vim.o.hidden = true
vim.o.nofixendofline = true
vim.o.nostartofline = true
vim.o.number = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.ignorecase = true
vim.o.cursorline = true

vim.o.nobackup = true
vim.o.nowritebackup = true
vim.o.noswapfile = true

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.laststatus=2
vim.o.noruler = true
vim.o.noshowmode = true
vim.o.signcolumn = true

vim.o.mouse = 'a'
vim.o.updatetime = 1000
" }}}

set scrolloff=999
set sidescroll=1
--[[
" Multi cursor
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax
Plug 'styled-components/vim-styled-components'
Plug 'prisma/vim-prisma'
Plug 'hashivim/vim-terraform'
Plug 'adelarsq/vim-matchit'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'isobit/vim-caddyfile'
Plug 'jonsmithers/vim-html-template-literals'

" coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Colorscheme
Plug 'gruvbox-community/gruvbox'

" Statusline
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'

" Vim JsDoc
Plug 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'javascript.jsx','typescript'],
  \ 'do': 'make install'
\}

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



let g:htl_all_templates = 1

function! SmartNERDTree()
    if @% == ""
        NERDTreeToggle
    else
        NERDTreeFind
    endif
endfun

map <C-t> :call SmartNERDTree()<CR>


let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-deno', 'coc-css']

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

set noerrorbells visualbell t_vb=

command AutoSave autocmd TextChanged,TextChangedI <buffer> silent write
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
command! -nargs=0 Deno :CocCommand deno.initializeWorkspace
command! -nargs=0 Format :call CocActionAsync('format')

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> qf <Plug>(coc-fix-current)
nmap <silent> ca <Plug>(coc-codeaction)
nmap <silent> ci <Plug>(coc-diagnostic-info)
nmap <silent> rr <Plug>(coc-rename)
nmap <C-Left> b
nmap <C-Right> w
nmap p P

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-.> coc#refresh()

nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

autocmd BufEnter * syntax sync fromstart
--]]
