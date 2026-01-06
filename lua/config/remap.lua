----------------------------------------------------
-- General
----------------------------------------------------
vim.g.mapleader = " "
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

----------------------------------------------------
-- Editor
----------------------------------------------------
-- Opens the file explorer
vim.keymap.set("n", "<leader>pv", "<cmd> :Ex <CR>")

-- Start a new tmux session
vim.keymap.set("n", "<C-t>", "<cmd>silent !tmux neww<CR>")


----------------------------------------------------
-- Navigation
----------------------------------------------------
-- Move focus between panes
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

-- Move while in insert mode
vim.keymap.set("i", "<C-b>", "<Esc>^i")
vim.keymap.set("i", "<C-e>", "<End>")
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-l>", "<Right>")

-- Move visual selected block
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Centering screen when moving page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Centering screen when navigating searched words
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without overwritting the yanked text
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Unbinding arrow keys
vim.keymap.set("n", "<Up>", "<Nop>")
vim.keymap.set("n", "<Down>", "<Nop>")
vim.keymap.set("n", "<Left>", "<Nop>")
vim.keymap.set("n", "<Right>", "<Nop>")


----------------------------------------------------
-- Diagnostics
----------------------------------------------------
vim.keymap.set("n", "<leader>q", function()
  vim.cmd(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and "cclose" or "copen")
end)
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")


----------------------------------------------------
-- Utilities
----------------------------------------------------
-- Make the opened file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Comment/uncomment selected block
vim.keymap.set("n", "<leader>/", "gcc", { remap = true })
vim.keymap.set("v", "<leader>/", "gc", { remap = true })

----------------------------------------------------
-- Terminal apps
----------------------------------------------------
vim.keymap.set("n", "<leader>lg", function() require("helpers.terminal_app").floating_terminal_app("lazygit") end)
vim.keymap.set("n", "<leader>ld", function() require("helpers.terminal_app").floating_terminal_app("lazydocker") end)
