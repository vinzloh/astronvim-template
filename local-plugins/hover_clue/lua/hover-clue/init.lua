local M = {}
local enabled = false

local has_lsp = function()
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method "textDocument/hover" then return true end
  end
  return false
end

function M.setup()
  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    desc = "On cursor, show clue",
    callback = function()
      if enabled and has_lsp() then
        --
        vim.lsp.buf.hover()
      end
    end,
  })
end

function M.toggle() enabled = not enabled end

return M
