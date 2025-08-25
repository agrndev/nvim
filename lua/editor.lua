--------------------------------------------
-- Gemeral
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
