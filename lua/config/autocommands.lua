---------------------------------------------------------
-- Highlight on yank
---------------------------------------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

---------------------------------------------------------
-- (WSL) Yank directly to Window's clipboard
---------------------------------------------------------
local clip = "/mnt/c/Windows/System32/clip.exe"
if vim.fn.executable(clip) then
  local opts = {
    callback = function()
      if vim.v.event.operator ~= "y" then
        return
      end
      vim.fn.system(clip, vim.fn.getreg(0))
    end,
  }
  opts.group = vim.api.nvim_create_augroup("WSLYank", {})
  vim.api.nvim_create_autocmd("TextYankPost", { group = opts.group, callback = opts.callback })
end

---------------------------------------------------------
-- Remap Netrw commands
---------------------------------------------------------
vim.api.nvim_create_autocmd("filetype", {
  pattern = "netrw",
  callback = function()
    local opts = { buffer = true, noremap = true, silent = true }
  end,
})
