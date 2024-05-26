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
          ["<Leader>k"] = {
            -- TODO: Improve filter results, weird stuff
            desc = "Keymaps",
            function() require("telescope.builtin").keymaps() end,
          },
          ["<Leader>to"] = {
            desc = "Open terminal cwd",
            function() vim.fn.jobstart "alacritty" end,
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
    keys = {
      {
        "<Leader>xc",
        desc = "TypeScript: Restart Server",
        function() vim.cmd.VtsExec "restart_tsserver" end,
      },
      {
        "<Leader>xo",
        desc = "TypeScript: Organize Imports",
        function() vim.cmd.VtsExec "organize_imports" end,
      },
    },
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
  -- TODO: `package.json` - open dep repo url
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
    -- NOTE: `opts = {}` is the same as calling `require('trouble').setup({})`
    opts = {},
    keys = {
      { "<Leader>xx", ":TroubleToggle<cr>", desc = "Toggle Trouble" },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {},
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>o"] = {
                desc = "Refresh Sidebar",
                function() vim.cmd.Neotree "dir=./" end, -- sync up vim cwd with neotree
              },
            },
          },
        },
      },
    },
  },
  {
    -- Auto update imports after file rename
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = function() require("lsp-file-operations").setup() end,
  },
  {
    dev = true,
    dir = "hover_clue",
    opts = {},
    keys = {
      {
        desc = "Toggle cursor hint",
        "<Leader>xh",
        function() require("hover-clue").toggle() end,
      },
    },
  },
}
