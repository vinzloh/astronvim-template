-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.recipes.heirline-vscode-winbar" },
  { import = "astrocommunity.recipes.vscode-icons" },
  { import = "astrocommunity.colorscheme.night-owl-nvim", lazy = false, priority = 1000 },
  { import = "astrocommunity.project.nvim-spectre" },
  -- { import = "astrocommunity.pack.typescript" },
  -- import/override with your plugins folder
}
