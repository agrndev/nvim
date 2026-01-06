local M = {}

function M.create_buffer()
  local buf = vim.api.nvim_create_buf(false, true)
  return buf
end

function M.create_split_buffer(width_scale)
  local buf = vim.api.nvim_create_buf(false, true)

  local columns = vim.o.columns
  local width = math.floor(columns * width_scale)

  vim.cmd("vsplit")

  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(win, width)
  vim.api.nvim_win_set_buf(win, buf)

  return buf
end


function M.create_floating_buffer(width_scale, height_scale)
  local buf = vim.api.nvim_create_buf(false, true)

  local columns = vim.o.columns
  local lines = vim.o.lines

  local width = math.floor(columns * width_scale)
  local height = math.floor(lines * height_scale)

  local col = math.floor((columns - width) / 2)
  local row = math.floor((lines - height) / 2)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  })

  return buf
end

return M
