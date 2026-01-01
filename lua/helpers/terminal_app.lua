local M = {}

function M.terminal_app(app)
  local buf = require("helpers.buffer").create_buffer()
  vim.api.nvim_set_current_buf(buf)
  vim.fn.termopen(app)

  vim.cmd("startinsert")
end

function M.split_terminal_app(app, focus_new_buffer)
  local previous_buf = vim.api.nvim_get_current_buf()

  local buf = require("helpers.buffer").create_split_buffer(0.6)
  vim.api.nvim_set_current_buf(buf)
  vim.fn.termopen(app)

  if focus_new_buffer == nil or focus_new_buffer == true then
    return
  end

  vim.api.nvim_set_current_buf(previous_buf)
end

function M.floating_terminal_app(app)
  local buf = require("helpers.buffer").create_floating_buffer(0.6, 0.8)
  vim.api.nvim_set_current_buf(buf)
  vim.fn.termopen(app)

  vim.cmd("startinsert")
end

return M
