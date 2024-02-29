-- vim:foldmethod=marker:foldlevel=0
-- BOOTSTRAP LAZY.NVIM PACKAGE MANAGER {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)
--- }}}

-- LEADER KEY {{{
-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- }}}

-- INSTALL AND CONFIGURE PLUGINS
require("lazy").setup({
  -- AUTOCOMPLETION / LSP PLUGINS {{{
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    lazy = true,
    config = function()
      -- Note: autocompletion settings will not take effect here
      require('lsp-zero.settings').preset({})
    end
  }, { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  {
    'hrsh7th/nvim-cmp', -- Autocompletion
    event = 'InsertEnter',
    dependencies = {
      -- { 'L3MON4D3/LuaSnip' }
    },
    config = function() require('lsp-zero.cmp').extend() end
  }, {
  'neovim/nvim-lspconfig', -- LSP configuration
  cmd = 'LspInfo',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' }, {
    'williamboman/mason.nvim',
    build = function() pcall(vim.cmd, 'MasonUpdate') end,
    config = function() require('mason').setup() end
  }, {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'lua_ls', 'volar', 'elixirls', 'eslint',
          'tailwindcss'
        }
      }
    end
  }
  },
  config = function()
    -- This is where all the LSP shenanigans will live
    local lsp = require('lsp-zero')

    lsp.on_attach(function(client, bufnr)
      lsp.default_keymaps({ buffer = bufnr })
    end)

    -- (Optional) Configure lua language server for neovim
    require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
    require('lspconfig').volar.setup {
      filetypes = { 'typescript', 'vue' },
      init_options = {
        typescript = {
          tsdk = '~/.asdf/installs/nodejs/16.19.1/lib/node_modules/typescript/lib'
        }
      }
    }
    -- -- solargraph
    -- require 'lspconfig'.solargraph.setup {}
    lsp.setup()
  end
}, { 'onsails/lspkind.nvim' }, -- { 'github/copilot.vim' },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua",
      config = function()
        require("copilot").setup({
          suggestion = { enabled = false },
          panel = { enabled = false }
        })
      end
    },
    config = function() require("copilot_cmp").setup() end
  },
  {
    "Bryley/neoai.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    cmd = {
        "NeoAI",
        "NeoAIOpen",
        "NeoAIClose",
        "NeoAIToggle",
        "NeoAIContext",
        "NeoAIContextOpen",
        "NeoAIContextClose",
        "NeoAIInject",
        "NeoAIInjectCode",
        "NeoAIInjectContext",
        "NeoAIInjectContextCode",
    },
    keys = {
        { "<leader>as", desc = "summarize text" },
        { "<leader>ag", desc = "generate git message" },
        { "<leader>aa", "<Cmd>NeoAIToggle<CR>", desc = "Toggle AI Chat" },
    },
    config = function()
        require("neoai").setup({
          models = {
              {
                  name = "openai",
                  -- model = "gpt-4",
                  model = "gpt-3.5-turbo",
                  params = nil,
              },
          },
        open_ai = {
            api_key = {
                env = "OPENAI_API_KEY",
            }
        }
      })
    end,
  },
  --- }}}
  -- COLORSCHEME PLUGINS {{{
  {
    'f-person/auto-dark-mode.nvim', -- auto switch between dark/light themes
    config = function()
      local auto_dark_mode = require('auto-dark-mode')

      local set_dark_mode = function()
        vim.api.nvim_set_option('background', 'dark')
        vim.cmd.colorscheme "catppuccin-macchiato"
      end

      local set_light_mode = function()
        vim.api.nvim_set_option('background', 'light')
        vim.cmd.colorscheme "catppuccin-latte"
      end

      set_dark_mode() -- default

      auto_dark_mode.setup({
        -- see dark/light functions below in COLORSCHEME section
        update_interval = 5000,
        set_dark_mode = set_dark_mode,
        set_light_mode = set_light_mode
      })
      auto_dark_mode.init()
    end,
    dependencies = {
      { "folke/tokyonight.nvim", branch = "main" },
      {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
          transparent_background = false,
          dim_inactive = {
              enabled = true,
              shade = "dark",
              percentage = 0.15, -- percentage of the shade to apply to the inactive window
          },
        }
      }
    }
  },                    --- }}}
  -- FILESYSTEM RELATED PLUGINS {{{
  "tpope/vim-eunuch",   -- Unix helpers from Vim. :Rename, :Delete, :Mkdir, etc
  "pbrisbin/vim-mkdir", -- Auto create missing paths for new files
  -- }}}
  -- FILE NAVIGATION PLUGINS {{{
  -- {
  --   'prichrd/netrw.nvim',
  --   dependencies = { 'nvim-tree/nvim-web-devicons' },
  --   config = true
  -- },
  {
    'stevearc/oil.nvim',
    config = function()
      require("oil").setup({
        default_file_explorer = false,
      })
      vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
    end
  }, -- {
  --   'tpope/vim-vinegar', -- Better netrw navigation. Use - to open directory of current buffer
  --   config = function()
  --     -- Map N to new file
  --     -- Map ? to help with netrw
  --     vim.api.nvim_exec(
  --       [[
  --     au FileType netrw nnoremap ? :help netrw-quickmap<CR>
  --     au FileType netrw nmap <buffer> N %
  --     ]],
  --       false)
  --   end
  -- },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
  --     "MunifTanjim/nui.nvim",
  --   },
  --   opts = {
  --     window = {
  --       mappings = {
  --             ["<space>"] = "noop",
  --             ["/"] = "noop",
  --       }
  --     },
  --     filesystem = {
  --       -- hijack_netrw_behavior = "disabled",
  --       filtered_items = {
  --         hide_by_name = {
  --           "node_modules",
  --           "Caches",
  --           "Backups"
  --         }
  --       }
  --     }
  --     -- sort_function = function(a, b)
  --     --   if ((a.type == b.type) or a.name:find("^%d") or b.name:find("^%d")) then
  --     --     return a.path < b.path
  --     --   else
  --     --     return a.type < b.type
  --     --   end
  --     -- end
  --   },
  --   config = function(_, opts)
  --     vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
  --     vim.keymap.set('n', '-', '<cmd>:Neotree current reveal<cr>', { desc = "File Explorer in current buffer" })
  --     require("neo-tree").setup(opts)
  --   end
  -- },
  -- {
  --   's1n7ax/nvim-window-picker',
  --   config = function()
  --       require'window-picker'.setup()
  --   end,
  -- },
  -- }}}
  -- FUZZY FINDER PLUGINS {{{
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", "Caches", "Backups" },
        mappings = {
          i = {
            ["<C-t>"] = false
          },
          n = {
            ["<C-t>"] = false
          },
        },
      },
      pickers = {
        buffers = {
          ignore_current_buffer = true,
          sort_lastused = true,
        }
      }
    }
  },
  -- {
  --   "danielfalk/smart-open.nvim", -- Smarter fuzzy-finding algorithm for telescope
  --   dependencies = { "kkharji/sqlite.lua" },
  --   branch = "0.1.x",
  --   config = function()
  --     require "telescope".load_extension("smart_open")
  --   end,
  -- },
  --- }}}
  -- GIT PLUGINS {{{
  {
    'tpope/vim-fugitive', -- Git Wrapper
    config = function()
      -- Use vertical split diff
      vim.opt.diffopt = vim.opt.diffopt + 'vertical'
    end
  },
  'tpope/vim-rhubarb',     -- Git Browse -> Github
  -- "almo7aya/openingh.nvim",   -- Open file in Github
  'kdheepak/lazygit.nvim',    -- open lazygit in vim
  {
    'sindrets/diffview.nvim', -- better diff
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  }, {
  'lewis6991/gitsigns.nvim', -- git icons in the gutter
  config = true,
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' }
    },
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 1000,
      ignore_whitespace = false
    }
  }
}, --- }}}
  -- KEYMAPPING PLUGINS {{{
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    lazy = true,
    opts = {
      plugins = { spelling = true },
      key_labels = { ["<leader>"] = "SPC" }
    },
    config = function(_, opts)
      -- full setup for key mappings is below
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      local wk = require("which-key")
      wk.setup(opts)
    end
  }, --- }}}
  -- LANGUAGE SPECIFIC PLUGINS {{{
  'slim-template/vim-slim', { 'NvChad/nvim-colorizer.lua', config = true },
  -- }}}
  -- LOCAL PROJECT-SPECIFIC OVERRIDES {{{
  {
    'embear/vim-localvimrc', -- override config by project in .lvimrc files
    -- I use this primarily for overriding my vim-test commands in projects
    -- that use docker locally.
    init = function()
      vim.api.nvim_exec([[
      let g:localvimrc_name=[".lvimrc", ".lvimrc.lua", ".nvimlocal.lua"]
      let g:localvimrc_ask=0
      let g:localvimrc_sandbox=0
      ]], false)
    end
  }, -- }}}
  -- SEARCH PLUGINS {{{
  {
    'windwp/nvim-spectre', -- find/replace across files
    dependencies = { 'nvim-lua/plenary.nvim' }
  },                       -- }}}
  -- TESTING {{{
  {
    'janko-m/vim-test',                -- Execute tests using keyboard shortcuts
    dependencies = {
      'christoomey/vim-tmux-runner',   -- Run tests from vim-test in a tmux pane
      'christoomey/vim-tmux-navigator' -- Easier navigation between vim and tmux
    },
    config = function()
      vim.api.nvim_exec([[
      if exists('$TMUX')
        let test#strategy = "vtr" " Run tests in tmux pane
      else
        let test#strategy = "neovim" " Run tests in integrated terminal
      endif
      ]], false)

      vim.g["test#ruby#rspec#options"] = { file = "--format documentation" }
      vim.g["test#preserve_screen"] = 1
    end
  }, -- }}}
  -- TEXT EDITING PLUGINS {{{
  {
    'numToStr/Comment.nvim', -- "gcc" to comment visual regions/lines
    config = true
  },                         -- }}}
  -- TREESITTER PLUGINS {{{
  {
    "RRethy/nvim-treesitter-endwise",
    dependencies = { "nvim-treesitter/nvim-treesitter" }
  }, {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  opts = {
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
    context_commentstring = { enable = true, enable_autocmd = false },
    endwise = { enable = true },
    ensure_installed = {
      'eex', 'elixir', 'graphql', 'heex', 'html', 'javascript',
      'json', 'lua', 'markdown', 'markdown_inline', 'python', 'ruby',
      'typescript', 'vim', 'yaml'
    }
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end
}, -- }}}
  {
    'akinsho/bufferline.nvim',
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      {
        "<leader>bP",
        "<Cmd>BufferLineGroupClose ungrouped<CR>",
        desc = "Delete non-pinned buffers"
      }
    },
    opts = {
      options = {
        always_show_bufferline = true,
        diagnostics = "nvim_lsp",
        -- groups = {
        --   options = {
        --     toggle_hidden_on_enter = true -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
        --   },
        --   items = {
        --     {
        --       name = "Specs", -- Mandatory
        --       highlight = {underline = true, sp = "blue"}, -- Optional
        --       priority = 2, -- determines where it will appear relative to other groups (Optional)
        --       icon = "", -- Optional
        --       matcher = function(buf) -- Mandatory
        --         local name = vim.api.nvim_buf_get_name(buf.id)
        --         return name:match('%_test') or name:match('%_spec')
        --       end,
        --     },
        --   }
        -- }
      }
    }
  },
  {
  "echasnovski/mini.bufremove",
  -- stylua: ignore
  keys = {
    {
      "<leader>bd",
      function()
        require("mini.bufremove").delete(0, false)
      end,
      desc = "Delete Buffer"
    }, {
    "<leader>bD",
    function()
      require("mini.bufremove").delete(0, true)
    end,
    desc = "Delete Buffer (Force)"
  }
  }
}, {
  'nvim-lualine/lualine.nvim', -- Fancier statusline
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = true,
  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = '|',
      section_separators = ''
    },
    sections = {
      lualine_a = {
        {
          'mode',
          fmt = function(str)
            return str:sub(1, 1)
          end
        }
      },
      lualine_b = {},
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { 'filename', path = 1, shorting_target = 25 } },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    }
  },
},
-- }}}
  -- WRITING PLUGINS {{{
  {
    "preservim/vim-markdown", -- Markdown filetype
    dependencies = { 'godlygeek/tabular' },
    config = function()
      -- vim.api.nvim_set_var('vim_markdown_conceal', 0) -- Conceal markdown characters on lines besides current one
      -- vim.api.nvim_set_var('vim_markdown_conceal_code_blocks', 0) -- Except code
      vim.api.nvim_set_var('vim_markdown_new_list_item_indent', 2)
    end
  },
  'itspriddle/vim-marked',
  {
    'lervag/wiki.vim',
    config = function()
      vim.g.wiki_root = '/Users/adam/Notes'
      vim.g.wiki_filetypes = { 'md', 'markdown' }
      vim.g.wiki_link_target_type = 'md'
      vim.g.wiki_mappings_use_defaults = 'none'

      vim.g.wiki_journal = {
        name = 'Working Memory',
        root = '/Users/adam/Notes/Working Memory',
        frequency = 'daily',
        date_format = {
          daily = '%Y-%m-%d',
          weekly = '%Y_w%V',
          monthly = '%Y_m%m'
        },
      }
      -- vim.g.wiki_templates = {
      --   { match_re = "\\d{4}\\d{2}\\d{2}",
      --     source_filename = ""
      --   }
      -- }
    end
  },
  -- {
  -- 'jakewvincent/mkdnflow.nvim',
  -- config = function()
  --   require('mkdnflow').setup({
  --     to_do = {
  --       symbols = { ' ', 'x', '-', '>' },
  --       update_parents = false,
  --       not_started = ' ',
  --       in_progress = '/',
  --       complete = 'x'
  --     },
  --     mappings = {
  --       MkdnIncreaseHeading = false,
  --       MkdnDecreaseHeading = false
  --     }
  --   })
  -- end
  -- },
  {
    "folke/twilight.nvim" -- Dim inactive portions of the file you're editing
  }, {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {
        window = { backdrop = 0.95, options = { number = false } },
        plugins = {
          gitsigns = { enabled = true },
          tmux = { enabled = false },
          twilight = { enabled = false }
        }
      }
    end
  },
  "jkramer/vim-checkbox",
  "davidoc/taskpaper.vim"
    -- }}}
})

-- EDITOR BASIC SETTINGS {{{
-- See `:help vim.o`
-- Use system clipboard
vim.o.clipboard = "unnamed"

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true
vim.o.undodir = vim.fn.expand("~/.tmp")

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set folding method
vim.o.foldmethod = "indent"
vim.o.foldlevelstart = 99
-- Always show the tab bar
vim.opt.showtabline = 2

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- TODO: add comments to these
vim.o.ruler = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.termguicolors = true
vim.o.lazyredraw = true
vim.o.showmode = false
vim.o.incsearch = true
vim.o.errorbells = false
vim.o.visualbell = true
vim.o.cursorline = true
vim.o.inccommand = "nosplit"
vim.o.autoread = true
-- }}}

-- HIGHLIGHT ON YANK {{{
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight',
  { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
  pattern = '*'
})
-- }}}

-- KEYBINDINGS {{{
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true })

vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<M-l>", "<cmd>BufferLineMovePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<M-h>", "<cmd>BufferLineMoveNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>edit #<cr>", { desc = "Toggle Buffer" })

-- whichkey show discoverable menu of keybindings when you press the leader key (space)
local wk = require("which-key")

local gbrowseMappings = {
  name = "GitHub",
  -- c = { "<cmd>:OpenInGHFile+<CR>", "Copy Link" },
  -- o = { "<cmd>:OpenInGHFile<CR>", "Open in Github" },
  c = { "<cmd>:GBrowse!<CR>", "Copy Link" },
  C = { "<cmd>:GBrowse! origin/master:%<CR>", "Copy Link (Master)" },
  o = { "<cmd>:GBrowse<CR>", "Open on Github" },
  O = { "<cmd>:GBrowse origin/master:%<CR>", "Open on Github (Master)" },
  p = { "<cmd>!gh pr view --web<CR>", "Open PR on Github" },
}

wk.register({
  mode = { "n" },
  -- [" "] = { function() require('telescope').extensions.smart_open.smart_open({ cwd_only = true }) end, "Find File" },
  [" "] = { "<cmd>Telescope find_files<cr>", "Find File" },
  -- [" "] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Switch Buffer" },
  -- [","] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Switch Buffer" },
  [","] = {
    function()
      require('telescope.builtin').buffers({
        sorting_strategy = "ascending"
      })
    end, "Switch Buffer"
  },
  d = { function() require("mini.bufremove").delete(0, false) end, "Delete Buffer" },
  ["/"] = {
    function() require('telescope.builtin').live_grep() end, "Live Grep"
  },
  ["Z"] = {
    function()
      require("zen-mode").toggle({
        window = { width = 120, options = { number = true } }
      })
    end, "Zen Mode"
  },
  ["z"] = {
    function()
      require("zen-mode").toggle({
        window = { width = 85, options = { number = false } }
      })
    end, "Zen Mode (Writing)"
  },
  -- ["e"] = { ":Neotree toggle<cr>", "File Explorer" },
  -- ["E"] = { ":Neotree reveal<cr>", "File Explorer (current file)" },
  f = {
    name = "Files",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    -- f = { function() require('telescope').extensions.smart_open.smart_open({ cwd_only = true }) end, "Find File" },
    r = {
      function() require('telescope.builtin').oldfiles() end,
      "Recent Files"
    },
    b = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Buffers" }
  },
  b = { name = "Buffers" },
  c = {
    name = "Code",
    a = { vim.lsp.buf.code_action, '[A]ction' },
    f = { vim.lsp.buf.format, '[F]ormat' },
    d = { "<cmd>:TroubleToggle<cr>", "Show [D]iagnostics" },
    r = {
      function() require('telescope.builtin').lsp_references() end,
      "[R]eferences"
    },
    R = { vim.lsp.buf.rename, "[R]ename" },
    h = { vim.lsp.buf.hover, '[H]over Documentation' },
    s = { vim.lsp.buf.signature_help, '[S]ignature Documentation' }
  },
  g = {
    name = "Git",
    s = { "<cmd>:G<cr>", "Status" },
    b = { "<cmd>:Git blame<cr>", "Blame" },
    B = {
      function()
        require('telescope.builtin').git_branches({
          show_remote_tracking_branches = false
        })
      end, "Branches"
    },
    d = { ":Gdiffsplit<CR>", "Diff" },
    c = { ":Git commit<CR>", "Commit" },
    a = { ":Git commit --amend<CR>", "Amend" },
    h = gbrowseMappings,
    p = { ":Git push<CR>", "Push" },
    F = { ":Git push --force-with-lease<CR>", "Force Push" },
    P = { ":Git pull<CR>", "Pull" },
    r = {
      name = "Rebase",
      m = { "<cmd>:Git rebase master<CR>", "Master" },
      c = { "<cmd>:Git rebase --continue<CR>", "Continue" }
    },
    S = {
      name = "Stash",
      s = { "<cmd>:Git stash<CR>", "Stash" },
      p = { "<cmd>:Git stash pop<CR>", "Pop" }
    },
    o = {
      name = "Open in...",
      l = { ":LazyGit<CR>", "LazyGit" },
      s = { ":! smerge .<CR>", "Sublime Merge" },
      g = { ":! gitup<CR>", "Gitup" }
    }
  },
  h = {
    name = "Help",
    t = { "<cmd>:Telescope builtin<cr>", "Telescope" },
    c = { "<cmd>:Telescope commands<cr>", "Commands" },
    h = { "<cmd>:Telescope help_tags<cr>", "Help Pages" },
    m = { "<cmd>:Telescope man_pages<cr>", "Man Pages" },
    k = { "<cmd>:Telescope keymaps<cr>", "Key Maps" }
  },
  s = {
    name = "Search",
    r = { "<cmd>lua require('spectre').open()<CR>", "Replace" },
    ["/"] = {
      function() require('telescope.builtin').live_grep() end, "Live Grep"
    }
  },
  t = {
    name = "Test",
    l = { ":TestNearest<CR>", "Line" },
    f = { ":TestFile<CR>", "File" },
    r = { ":TestLst<CR>", "Repeat Last" },
    t = "which_key_ignore"
  },
  w = {
    name = "Working memory",
    w = { ":WikiJournal<cr>", "Today" },
    -- t = { ":WikiJournal<cr>", "Today" },
    n = { ":WikiJournalNext<cr>", "Next Day" },
    p = { ":WikiJournalPrev<cr>", "Prev Day" }
  }
}, { prefix = "<leader>" })

wk.register({
  mode = { "n", "v" },
  g = { name = "Git", h = gbrowseMappings },
  triggers = "auto"
}, { prefix = "<leader>" })
-- }}}

-- NVIM-CMP SETUP {{{
local cmp = require 'cmp'
-- local luasnip = require 'luasnip'

cmp.setup {
  -- snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- elseif luasnip.expand_or_jumpable() then
      --   luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      -- elseif luasnip.jumpable(-1) then
      --   luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' })
  },
  sources = {
    { name = 'nvim_lsp' },
    -- { name = 'luasnip' },
    { name = "copilot", group_index = 2 }
  },
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'symbol',
      maxwidth = 50,
      ellipsis_char = '...',
      symbol_map = { Copilot = "" }
    })
  }
}
--- }}}

-- PERSIST CURSOR {{{

-- When editing a file, always jump to the last known cursor position.
-- Don't do it for commit messages, when the position is invalid, or when
-- inside an event handler (happens when dropping a file on gvim).

vim.api.nvim_exec([[
  autocmd BufReadPost * if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
  ]], false)
-- }}}

-- SEARCH {{{
-- :Ag to search project using silver searcher https://github.com/ggreer/the_silver_searcher
vim.opt.grepprg = "ag --nogroup --nocolor"
vim.cmd [[command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!]]
-- }}}

-- WRITING / MARKDOWN {{{
vim.cmd [[au FileType markdown setl conceallevel=1]] -- Different conceal level on markdown
vim.cmd [[au FileType markdown setl wrap linebreak nolist]]
-- }}}

-- SPELL CHECK {{{
-- Spell-check Markdown files and Git commit messages
vim.api.nvim_command('autocmd FileType markdown setlocal spell')
vim.api.nvim_command('autocmd FileType gitcommit setlocal spell')
vim.api.nvim_command('autocmd FileType markdown setlocal complete+=kspell')
vim.api.nvim_command('autocmd FileType gitcommit setlocal complete+=kspell')
-- }}}

-- COMMAND MODE OVERRIDES {{{
-- Override common mistakes in command mode
vim.api.nvim_exec([[
cnoreabbrev E e
cnoreabbrev Tabe tabe
cnoreabbrev W w
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev WA wa
cnoreabbrev Wa wa
cnoreabbrev ack Ag
cnoreabbrev Ack Ag
cnoreabbrev ACk Ag
cnoreabbrev AG Ag
cnoreabbrev Gblame Git blame
cnoreabbrev GBlame Git blame
cnoreabbrev Gbrowse GBrowse
cnoreabbrev tabe NOTABS
cnoreabbrev tabnew NOTABS
]], false)
-- }}}
