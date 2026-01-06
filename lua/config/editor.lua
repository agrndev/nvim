--------------------------------------------
-- General
--------------------------------------------
vim.opt.clipboard = "unnamedplus"

--------------------------------------------
-- Theme
--------------------------------------------
vim.o.background = "dark"


--------------------------------------------
-- Identation
--------------------------------------------
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true


--------------------------------------------
-- Navigation
--------------------------------------------
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.incsearch = true


--------------------------------------------
-- LSP
--------------------------------------------
-- Enables the in-line error/warning message
vim.diagnostic.config({ virtual_text = true })


--------------------------------------------
-- Netrw
--------------------------------------------
vim.g.netrw_winsize = 20

vim.g.netrw_banner = 0

-- Keep the current directory and the browsing directory synced.
-- This helps you avoid the move files error.
vim.g.netrw_keepdir = 0

-- Show directories first (sorting)
vim.g.netrw_sort_sequence = [[[\/]$,*]]

-- Human-readable files sizes
vim.g.netrw_sizestyle = "H"

-- Tree style listing
vim.g.netrw_liststyle = 3

-- Preview files in a vertical split window
vim.g.netrw_preview = 1

-- Show not-hidden files
vim.g.netrw_hide = 1

vim.g.netrw_localcopydircmd='cp -r'
