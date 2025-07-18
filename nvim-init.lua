---@diagnostic disable-next-line: unused-function
-- Function for debugging
local function inspect(t, indent)
  indent = indent or 0
  for k, v in pairs(t) do
    if type(v) == "table" then
      print(string.rep(" ", indent) .. k .. " = {")
      inspect(v, indent + 2)
      print(string.rep(" ", indent) .. "}")
    else
      print(string.rep(" ", indent) .. k .. " = " .. tostring(v))
    end
  end
end

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
          adaptive_size = true,
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
        },
        on_attach = nvim_tree_on_attach
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
        },
        pickers = {
          live_grep = {
            additional_args = function()
              return { "--hidden", "--glob", "!.git" }
            end
          },
        },
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
  { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown" } },
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
    },
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = vim.loop.os_uname().machine ~= "aarch64",
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
  {
    "fannheyward/telescope-coc.nvim",
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require("startup").setup({
        require("telescope").setup({
          extensions = {
            coc = {
              theme = 'ivy',
              prefer_locations = false,
              push_cursor_on_edit = true,
              timeout = 8000,
            }
          },
        })
      })
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup()
    end
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile dapDebugServer && rm -rf out && mv dist out"
      }
    },
    keys = {
      { "ab", function() require 'dap'.toggle_breakpoint() end },
      { "ac", function() require 'dap'.continue() end },
      { "ao", function() require 'dap'.step_over() end },
      { "ai", function() require 'dap'.step_into() end },
      { "at", function() require 'dap'.step_out() end },
    },
    config = function()
      require("dap").adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/out/src/dapDebugServer.js", "${port}" },
        }
      }
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "attach",
            port = 9229,
            name = "Attach debugger to existing process",
            sourceMaps = true,
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**" },
            cwd = vim.fn.getcwd(),
            skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
          },
        }
      end

      require("dapui").setup()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ reset = true })
      end
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      vim.cmd("hi DapBreakpointColor guifg=#fa4848")
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpointColor", linehl = "", numhl = "" })
    end
  }
})

vim.o.smartindent = true
vim.o.fileformats = "unix,dos,mac"

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.textwidth = 160

vim.o.title = true
vim.o.wrap = false

vim.o.hidden = true
vim.o.startofline = false
vim.o.number = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cursorline = true
vim.opt.guicursor = {
  "n-v-c:block",
  "i:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
  "r-cr:hor20",
  "o:hor50",
  "ve:ver35",
  "ci:ver25",
  "sm:block-blinkwait175-blinkoff150-blinkon175",
}

vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.autoread = true

vim.o.scrolloff = 999
vim.o.sidescroll = 1

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.laststatus = 2
vim.o.signcolumn = "auto:3"
vim.o.pumheight = 10
vim.o.showmode = false
vim.o.ruler = false

vim.o.mouse = "a"
vim.o.updatetime = 300

vim.o.visualbell = false
vim.o.errorbells = false

vim.g.coc_global_extensions = { 'coc-json', 'coc-tsserver', 'coc-deno', 'coc-css', 'coc-prettier', 'coc-eslint',
  'coc-prisma', 'coc-yaml', 'coc-lua', 'coc-terraform', 'coc-docker', 'coc-sh', 'coc-html' }

vim.cmd [[colorscheme tokyonight]]

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

vim.api.nvim_create_user_command('Lg', 'Telescope live_grep', {});
vim.api.nvim_create_user_command('Tr', function()
  require('telescope.builtin').resume()
end, {});
vim.api.nvim_create_user_command('Treg', 'Telescope registers', {});
vim.api.nvim_create_user_command('Jumps', 'Telescope jumplist', {});
vim.api.nvim_create_user_command('Il', 'IBLToggle', {});
vim.api.nvim_create_user_command('Prettier', 'CocCommand prettier.forceFormatDocument', {});
vim.api.nvim_create_user_command('Deno', 'CocCommand deno.initializeWorkspace', {});
vim.api.nvim_create_user_command('Format', 'call CocActionAsync(\'format\')', {});
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
vim.api.nvim_create_user_command('GitShowInsert', function()
  local daysAgo = vim.fn.input('Days ago: ')
  vim.cmd('read !gshow ' .. daysAgo .. ' ' .. '"%:~:."')
end, {});
vim.api.nvim_create_user_command('SessionSave', function()
  vim.cmd('mksession! ~/.config/nvim/session.vim')
end, {});
vim.api.nvim_create_user_command('SessionRestore', function()
  vim.cmd('source ~/.config/nvim/session.vim')
end, {});
vim.api.nvim_create_user_command('TsNoCheck', 'call append(0, \'// @ts-nocheck\')', {});

local noop = function()
end

vim.keymap.set({ 'n' }, 'q', noop);
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

vim.keymap.set({ 'n', 'v', 'i' }, '<C-p>', function()
  require('telescope.builtin').find_files({ hidden = true })
end);
vim.keymap.set({ 'n' }, '<C-l>', '<Cmd>Telescope bookmarks list<CR>');
vim.keymap.set({ 'n', 'v', 'i' }, '<C-t>', '<Cmd>NvimTreeFindFile<CR>');
vim.keymap.set({ 'n', 'v', 'i' }, '<C-y>', '<Cmd>NvimTreeClose<CR>');

vim.keymap.set({ 'i' }, '<C-u>', require('uuid-nvim').insert_v4);

vim.keymap.set({ 'n' }, 'gd', '<Cmd>Telescope coc definitions<CR>');
vim.keymap.set({ 'n' }, 'gt', '<Cmd>Telescope coc type_definitions<CR>');
vim.keymap.set({ 'n' }, 'gi', '<Cmd>Telescope coc implementations<CR>');
vim.keymap.set({ 'n' }, 'gr', '<Cmd>Telescope coc references<CR>');
vim.keymap.set({ 'n' }, 'ca', '<Plug>(coc-codeaction)');
vim.keymap.set({ 'n' }, 'ci', '<Plug>(coc-diagnostic-info)');
vim.keymap.set({ 'n' }, 'rr', '<Plug>(coc-rename)');

vim.keymap.set({ 'n' }, '<C-n>', '<C-i>');

vim.keymap.set('n', '<TAB>', '>>', opts);
vim.keymap.set('n', '<S-TAB>', '<<', opts);
vim.keymap.set('v', '<TAB>', '<S->>gv', opts);
vim.keymap.set('v', '<S-TAB>', '<S-<>gv', opts);
vim.keymap.set({ 'n' }, 'p', 'P');

vim.cmd('source ~/.config/nvim/legacy.vim');
