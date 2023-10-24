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
          width = 60,
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
  },
  {
    "neoclide/coc.nvim", branch = 'release',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "prisma/vim-prisma"
  },
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
        'smoka7/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
            {
                mode = { 'v', 'n' },
                '<Leader>m',
                '<cmd>MCstart<cr>',
                desc = 'Create a selection for selected text or word under the cursor',
            },
        },
    }
})


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
vim.o.signcolumn = "auto"

vim.o.mouse = "a"
vim.o.updatetime = 300

vim.o.scrolloff = 999
vim.o.sidescroll = 1

vim.o.noerrorbells = true
vim.o.visualbell = false

vim.g.coc_global_extensions = { 'coc-json', 'coc-tsserver', 'coc-deno', 'coc-css', 'coc-prettier', 'coc-eslint', 'coc-prisma' }

vim.cmd[[colorscheme tokyonight]]

vim.api.nvim_create_user_command('Lg', 'Telescope live_grep', {});
vim.api.nvim_create_user_command('Prettier', 'CocCommand prettier.forceFormatDocument', {});
vim.api.nvim_create_user_command('Deno', 'CocCommand deno.initializeWorkspace', {});
vim.api.nvim_create_user_command('Format', 'call CocActionAsync(\'format\')', {});

vim.keymap.set({ 'n', 'v', 'i' }, '<C-p>', '<Cmd>Telescope find_files<CR>');
vim.keymap.set({ 'n', 'v', 'i' }, '<C-t>', '<Cmd>NvimTreeFindFile<CR>');
vim.keymap.set({ 'n' }, '<C-m>', '<Cmd>MCunderCursor<CR>');

vim.keymap.set({ 'n' }, 'gd', '<Plug>(coc-definition)');
vim.keymap.set({ 'n' }, 'gt', '<Plug>(coc-type-definition)');
vim.keymap.set({ 'n' }, 'gi', '<Plug>(coc-implementation)');
vim.keymap.set({ 'n' }, 'gr', '<Plug>(coc-references)');
vim.keymap.set({ 'n' }, 'qf', '<Plug>(coc-fix-current)');
vim.keymap.set({ 'n' }, 'ca', '<Plug>(coc-codeaction)');
vim.keymap.set({ 'n' }, 'ci', '<Plug>(coc-diagnostic-info)');
vim.keymap.set({ 'n' } , 'rr', '<Plug>(coc-rename)');

vim.keymap.set({ 'n' }, 'p', 'P');

vim.cmd('source ~/.config/nvim/legacy.vim');
