local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
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
      "nvim-tree/nvim-web-devicons",
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
          theme = 'tokyonight',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        }
      }
    end
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
          width = 50,
        },
        filters = {
          dotfiles = false,
        },
        actions = {
          open_file = {
            quit_on_open = vim.go.columns <= 200 and true or false
          }
        },
        update_focused_file = {
          enable = true,
        }
      }
    end,
  },
  {
    "neoclide/coc.nvim",
    branch = 'release',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "isobit/vim-caddyfile"
  },
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      'smoka7/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCunderCursor' },
    keys = {}
  },
  {
    "tomasky/bookmarks.nvim",
    config = function()
      require('bookmarks').setup {
        save_file = vim.fn.expand "$HOME/.config/nvim/bookmarks",
        on_attach = function(bufnr)
          local bm = require "bookmarks"
          local map = vim.keymap.set
          map("n", "mm", bm.bookmark_toggle)
          map("n", "mc", bm.bookmark_clean)
          map("n", "mn", bm.bookmark_next)
          map("n", "mp", bm.bookmark_prev)
        end
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          dynamic_preview_title = true
        }
      })
      require('telescope').load_extension('bookmarks')
    end
  },
  {
    'TrevorS/uuid-nvim',
    lazy = true,
    config = function()
      require('uuid-nvim').setup {
        case = 'lower',
        quotes = 'none'
      }
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "cat " .. vim.fn.expand("$HOME") .. "/.secret/oai.txt"
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
    },
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "bash",
          "c",
          "css",
          "diff",
          "dockerfile",
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "graphql",
          "hcl",
          "html",
          "http",
          "javascript",
          "jq",
          "jsdoc",
          "json",
          "jsonc",
          "lua",
          "luadoc",
          "luap",
          "make",
          "markdown",
          "markdown_inline",
          "prisma",
          "python",
          "query",
          "regex",
          "sql",
          "terraform",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "xml",
          "yaml",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
  {
    "startup-nvim/startup.nvim",
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require("startup").setup({
        theme = "dashboard",
      })
    end
  },
})

vim.o.smartindent = true

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.textwidth = 160

vim.o.title = true
vim.o.wrap = false

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

vim.o.scrolloff = 999
vim.o.sidescroll = 1

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.laststatus = 2
vim.o.noruler = true
vim.o.noshowmode = true
vim.o.signcolumn = "auto:3"
vim.o.pumheight = 10

vim.o.mouse = "a"
vim.o.updatetime = 300

vim.o.noerrorbells = true
vim.o.visualbell = false

vim.g.coc_global_extensions = { 'coc-json', 'coc-tsserver', 'coc-deno', 'coc-css', 'coc-prettier', 'coc-eslint',
  'coc-prisma', 'coc-yaml', 'coc-lua' }

vim.cmd [[colorscheme tokyonight]]

vim.api.nvim_create_user_command('Lg', 'Telescope live_grep', {});
vim.api.nvim_create_user_command('Prettier', 'CocCommand prettier.forceFormatDocument', {});
vim.api.nvim_create_user_command('Deno', 'CocCommand deno.initializeWorkspace', {});
vim.api.nvim_create_user_command('Format', 'call CocActionAsync(\'format\')', {});
vim.api.nvim_create_user_command('Mc', 'MCunderCursor', {});
vim.api.nvim_create_user_command('Find', function()
  require("spectre").toggle()
end, {});
vim.api.nvim_create_user_command('GitBlame', function()
  local currentLine = vim.fn.line('.')
  vim.cmd('!gblame "%:~:." ' .. currentLine);
end, {});
vim.api.nvim_create_user_command('GitShow', function()
  local daysAgo = vim.fn.input('Days ago: ')
  vim.cmd('!gshow ' .. daysAgo .. ' ' .. '"%:~:."')
end, {});

local noop = function()
end

vim.keymap.set({ 'n' }, 'q', noop);
vim.keymap.set({ 'n' }, 'w', noop);
vim.keymap.set({ 'n' }, 'e', noop);
vim.keymap.set({ 'n' }, 't', noop);
vim.keymap.set({ 'n' }, 'o', noop);
vim.keymap.set({ 'n' }, 'a', noop);
vim.keymap.set({ 'n' }, 's', noop);
vim.keymap.set({ 'n' }, 'f', noop);
vim.keymap.set({ 'n' }, 'z', noop);
vim.keymap.set({ 'n' }, 'x', noop);
vim.keymap.set({ 'n' }, 'b', noop);
vim.keymap.set({ 'n' }, ',', noop);
vim.keymap.set({ 'n' }, '.', noop);
vim.keymap.set({ 'n' }, '?', noop);
vim.keymap.set({ 'n' }, ';', noop);
vim.keymap.set({ 'n' }, '"', noop);
vim.keymap.set({ 'n' }, '[', noop);
vim.keymap.set({ 'n' }, ']', noop);
vim.keymap.set({ 'n' }, '-', noop);
vim.keymap.set({ 'n' }, '=', noop);
vim.keymap.set({ 'n' }, '_', noop);
vim.keymap.set({ 'n' }, '+', noop);
vim.keymap.set({ 'n' }, '{', noop);
vim.keymap.set({ 'n' }, '}', noop);
vim.keymap.set({ 'n' }, '?', noop);

vim.keymap.set({ 'n', 'v' }, '<C-Left>', '5h');
vim.keymap.set({ 'n', 'v' }, '<C-Right>', '5l');
vim.keymap.set({ 'n', 'v' }, '<S-Left>', '10h');
vim.keymap.set({ 'n', 'v' }, '<S-Right>', '10l');
vim.keymap.set({ 'n', 'v' }, '<C-Up>', '5k');
vim.keymap.set({ 'n', 'v' }, '<C-Down>', '5j');
vim.keymap.set({ 'n', 'v' }, '<S-Up>', '10k');
vim.keymap.set({ 'n', 'v' }, '<S-Down>', '10j');

vim.keymap.set({ 'n', 'v', 'i' }, '<C-p>', '<Cmd>Telescope find_files<CR>');
vim.keymap.set({ 'n' }, '<C-b>', '<Cmd>Telescope bookmarks list<CR>');
vim.keymap.set({ 'n', 'v', 'i' }, '<C-t>', '<Cmd>NvimTreeFindFile<CR>');

vim.keymap.set({ 'i' }, '<C-u>', require('uuid-nvim').insert_v4);

vim.keymap.set({ 'n' }, 'gd', '<Plug>(coc-definition)');
vim.keymap.set({ 'n' }, 'gt', '<Plug>(coc-type-definition)');
vim.keymap.set({ 'n' }, 'gi', '<Plug>(coc-implementation)');
vim.keymap.set({ 'n' }, 'gr', '<Plug>(coc-references)');
vim.keymap.set({ 'n' }, 'ca', '<Plug>(coc-codeaction)');
vim.keymap.set({ 'n' }, 'ci', '<Plug>(coc-diagnostic-info)');
vim.keymap.set({ 'n' }, 'rr', '<Plug>(coc-rename)');

vim.keymap.set('n', '<TAB>', '>>', opts);
vim.keymap.set('n', '<S-TAB>', '<<', opts);
vim.keymap.set('v', '<TAB>', '<S->>gv', opts);
vim.keymap.set('v', '<S-TAB>', '<S-<>gv', opts);
vim.keymap.set({ 'n' }, 'p', 'P');

vim.cmd('source ~/.config/nvim/legacy.vim');
