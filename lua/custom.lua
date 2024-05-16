---@type LazySpec
return {
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
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "vtsls",
        "eslint",
      })
    end,
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
    "yioneko/nvim-vtsls",
    lazy = false,
    -- dependencies = {
    --   "AstroNvim/astrocore",
    --   opts = {
    --     autocmds = {
    --       nvim_vtsls = {
    --         {
    --           event = "LspAttach",
    --           desc = "Load nvim-vtsls with vtsls",
    --           callback = function(args)
    --             if assert(vim.lsp.get_client_by_id(args.data.client_id)).name == "vtsls" then
    --               require("vtsls")._on_attach(args.data.client_id, args.buf)
    --               vim.api.nvim_del_augroup_by_name "nvim_vtsls"
    --             end
    --           end,
    --         },
    --       },
    --     },
    --   },
    -- },
    -- config = function(_, opts) require("vtsls").config(opts) end,
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
      current_line_blame = true,
      current_line_blame_formatter_opts = {
        relative_time = true,
      },
      signcolumn = true,
    },
  },
}
