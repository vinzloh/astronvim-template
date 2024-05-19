---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {

      options = {
        opt = { -- vim.opt.<key>
          relativenumber = false, -- sets vim.opt.relativenumber
          number = true, -- sets vim.opt.number
          spell = false, -- sets vim.opt.spell
          signcolumn = "auto", -- sets vim.opt.signcolumn to auto
          wrap = false, -- sets vim.opt.wrap
        },
      },

      -- Mappings can be configured through AstroCore as well.
      -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
      mappings = {
        -- first key is the mode
        n = {
          ["<Leader>SF"] = {
            desc = "Load a workspace",
            function()
              -- NOTE: if neo-tree open when load dirsession, buffer crash
              require("neo-tree.command").execute { action = "close" }
              require("resession").load(nil, { dir = "dirsession" })
            end,
          },
        },
      },

      -- Configuration table of session options for AstroNvim's session management powered by Resession
      sessions = {
        -- Configure auto saving
        autosave = {
          last = true, -- auto save last session
          cwd = true, -- auto save session for each working directory
        },
        -- Patterns to ignore when saving sessions
        ignore = {
          dirs = {}, -- working directories to ignore sessions in
          filetypes = { "gitcommit", "gitrebase" }, -- filetypes to ignore sessions
          buftypes = {}, -- buffer types to ignore sessions
        },
      },
      autocmds = {
        -- disable alpha autostart
        alpha_autostart = false,
        restore_session = {
          {
            event = "VimEnter",
            desc = "Restore previous directory session if neovim opened with no arguments",
            nested = true, -- trigger other autocommands as buffers open
            callback = function()
              -- Only load the session if nvim was started with no args
              if vim.fn.argc(-1) == 0 then
                -- try to load a directory session using the current working directory
                require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
                require("resession").load("Last Session", { silence_errors = true })
              end
            end,
          },
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      autocmds = {},
      ---@diagnostic disable: missing-fields
      config = {
        vtsls = {
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
              suggest = {
                completeFunctionCalls = true,
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
            vtsls = {
              autoUseWorkspaceTsdk = true,
              enableMoveToFileCodeAction = true,
            },
          },
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    priority = 60,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "vtsls",
        "eslint",
      })
    end,
  },
  {
    "yioneko/nvim-vtsls",
    lazy = false,
    priority = 60,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    lazy = true,
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "prettierd",
      })
    end,
  },
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    event = "BufRead package.json",
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "User AstroGitFile",
    opts = {
      signcolumn = true,
    },
  },
  {
    "f-person/git-blame.nvim",
    event = "User AstroGitFile",
    opts = {
      date_format = "%r",
      use_blame_commit_file_urls = true,
    },
    keys = {
      { "<Leader>go", ":GitBlameOpenCommitURL<cr>", desc = "Open commit URL" },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<Leader>xx", ":TroubleToggle<cr>", desc = "Toggle Trouble" },
    },
  },
  {
    "folke/edgy.nvim",
    enabled = false,
    event = "InsertEnter",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>e"] = {
                function() require("edgy").toggle() end,
                desc = "Toggle Sidebars",
              },
            },
          },
        },
      },
    },
    opts = {
      options = {
        left = { size = 40 },
        bottom = { size = 10 },
        right = { size = 30 },
        top = { size = 10 },
      },
      exit_when_last = true,
      top = {},
      bottom = {},
      left = {
        {
          title = "Files",
          ft = "neo-tree",
          filter = function(buf) return vim.b[buf].neo_tree_source == "filesystem" end,
          pinned = true,
          open = "Neotree position=left filesystem",
          size = { height = 0.5 },
        },
        {
          title = "Git Status",
          ft = "neo-tree",
          filter = function(buf) return vim.b[buf].neo_tree_source == "git_status" end,
          pinned = true,
          open = "Neotree position=right git_status",
        },
        {
          title = "Buffers",
          ft = "neo-tree",
          filter = function(buf) return vim.b[buf].neo_tree_source == "buffers" end,
          pinned = true,
          open = "Neotree position=top buffers",
        },
      },
      right = {},
      keys = {
        -- increase width
        ["<C-Right>"] = function(win) win:resize("width", 2) end,
        -- decrease width
        ["<C-Left>"] = function(win) win:resize("width", -2) end,
        -- increase height
        ["<C-Up>"] = function(win) win:resize("height", 2) end,
        -- decrease height
        ["<C-Down>"] = function(win) win:resize("height", -2) end,
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      -- source_selector = {
      --   winbar = false,
      --   statusline = false,
      -- },
      -- event_handlers = {
      --   {
      --     event = "vim_after_session_load",
      --     handler = function()
      --       vim.notify "vim_after_session_load"
      --       -- require("edgy").toggle() -- NOTE: open all 3 - files, git, buffers
      --       -- vim.cmd.Neotree "dir=./" -- NOTE: sync up vim cwd with neotree
      --     end,
      --   },
      -- },
    },
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>k"] = {
                desc = "Keymaps",
                function() require("telescope.builtin").keymaps() end,
              },
              ["<Leader>o"] = {
                desc = "Refresh Sidebar",
                function()
                  -- require("neo-tree.command").execute { action = "show" }
                  vim.cmd.Neotree "dir=./" -- NOTE: sync up vim cwd with neotree
                end,
              },
              ["<Leader>xc"] = {
                desc = "TypeScript: Restart Server",
                function() vim.cmd.VtsExec "restart_tsserver" end,
              },
              ["<Leader>xo"] = {
                desc = "TypeScript: Organize Imports",
                function() vim.cmd.VtsExec "organize_imports" end,
              },
            },
          },
        },
      },
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = function() require("lsp-file-operations").setup() end,
  },
}
