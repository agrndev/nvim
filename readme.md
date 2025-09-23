# Neovim as a Code Editor

## Table of Contents
* [What is Neovim?](#what-is-neovim)
* [Why Neovim?](#why-neovim)
* [Installing and Setting Up Configuration Folder](#installing-and-setting-up-configuration-folder)
* [What Will Be Done?](#what-will-be-done)
* [Laying the Foundation](#laying-the-foundation)
* [Initial Configurations](#initial-configurations)
* [Installing the Plugin Package Manager](#installing-the-plugin-package-manager)
* [Implementing Additional Features](#implementing-additional-features)
  * [Mason](#mason)
  * [lspconfig](#lspconfig)
  * [Treesitter](#treesitter)
  * [Telescope](#telescope)
  * [Code Formatting](#code-formatting)
  * [Code Suggestions](#code-suggestions)
  * [Debugging](#debugging)

## What is Neovim?
**Neovim** is a fork of Vim, a lightweight, efficient, and fast open-source code editor used directly in a terminal. With **Neovim**, you can use Lua to configure the editor and develop plugins to enhance functionality, creating a fully customized development environment based on your preferences.

## Why Neovim?
When installing an IDE like JetBrains or Visual Studio, you get a feature-rich code editor ready to use out of the box. However, **Neovim** initial's setup lacks basic features like syntax highlighting and code formatting.

**Why choose Neovim then?** Customization, speed, and a deeper understanding of your development tools is the answer.

## What Will Be Done?
This tutorial will implement essential editor features and optional ones based on user preferences and work environment, including:
* Syntax highlighting
* Code formatting
* Code suggestions
* Telescope for navigation and search
* Debugging
* Initial LSP setup
* Plugin Package Manager
* Package Manager for LSPs, DAPs, linters, and formatters

## Installing and Setting Up Configuration Folder
To install **Neovim**, use your preferred package manager. For Arch-based Linux distributions, run: `sudo pacman -S nvim` and follow the installation steps. To customize **Neovim**, create a configuration folder in the standard Linux `.config` directory with: `mkdir ~/.config/nvim`.

## Laying the Foundation
**Neovim** loads configurations from the `init.lua` file in the `~/.config/nvim` directory. This file serves as the entry point for loading configurations, organized into separate files by functionality for better organization.

```
.
├── init.lua
└── lua
    ├── autocmd.lua
    ├── editor.lua
    ├── lazy_init.lua
    ├── remap.lua
    └── plugins
        ├── dap
        │   ├── c.lua
        │   └── typescript.lua
        ├── completion.lua
        ├── dap.lua
        ├── formatter.lua
        ├── lsp.lua
        ├── mason.lua
        ├── telescope.lua
        ├── theme.lua
        └── treesitter.lua
```

Create the files and folders with:
```bash
cd ~/.config/nvim &&
touch init.lua &&
mkdir ./lua &&
touch ./lua/autocmd.lua &&
touch ./lua/editor.lua &&
touch ./lua/lazy_init.lua &&
touch ./lua/remap.lua &&
mkdir ./lua/plugins &&
touch ./lua/plugins/completion.lua &&
touch ./lua/plugins/dap.lua &&
touch ./lua/plugins/formatter.lua &&
touch ./lua/plugins/lsp.lua &&
touch ./lua/plugins/mason.lua &&
touch ./lua/plugins/telescope.lua &&
touch ./lua/plugins/theme.lua &&
touch ./lua/plugins/treesitter.lua &&
mkdir ./lua/plugins/dap &&
touch ./lua/plugins/dap/c.lua &&
touch ./lua/plugins/dap/typescript.lua
```

In `init.lua`, specify which modules to load:
```lua
require("editor")
require("remap")
require("autocmd")
require("lazy_init")
```

## Initial Configurations
Below are configurations for `remap.lua`, `editor.lua`, and `autocmd.lua`, with comments explaining the non-obvious functionality. For more options, check [Neovim's Quickrefs](https://neovim.io/doc/user/quickref.html#option-list).

### remap.lua
Handles keybindings and Neovim behaviors, such as setting the leader key and Vim motions.
```lua
vim.g.mapleader = " "
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Open file explorer
vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")

-- Navigate between panes
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

-- Move in insert mode
vim.keymap.set("i", "<C-b>", "<Esc>^i")
vim.keymap.set("i", "<C-e>", "<End>")
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-l>", "<Right>")

-- Move selected block in visual mode
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Center screen when paging
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Center screen when navigating search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without overwriting yanked text
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Comment/uncomment selected block
vim.keymap.set("n", "<leader>/", "gcc", { remap = true })
vim.keymap.set("v", "<leader>/", "gc", { remap = true })
```

### editor.lua
Configures editor settings like background color, indentation, and line numbers.
```lua
vim.o.background = "dark"

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.incsearch = true

-- Enable inline error/warning messages
vim.diagnostic.config({ virtual_text = true })
```

### autocmd.lua
Defines functions triggered by events (see [Neovim autocmd documentation](https://neovim.io/doc/user/autocmd.html)). Includes:
* Highlighting copied text on yank.
* Copying yanks to the Windows clipboard when using WSL2.
```lua
-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- (WSL) Copy to Windows clipboard
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
```

## Installing the Plugin Package Manager
Use [lazy.nvim](https://github.com/folke/lazy.nvim) to manage third-party dependencies. Note: `lazy.nvim` is distinct from `LazyVim`. Copy the following into `lazy_init.lua` and restart Neovim:
```lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  checker = { enabled = true },
})
```

This downloads `lazy.nvim` from GitHub if not already installed, sets it up, and imports `init.lua` files from the `plugins` directory.

## Implementing Additional Features
With `lazy.nvim` installed, add features via plugins.

### Mason
[Mason](https://github.com/mason-org/mason.nvim) manages LSPs, DAPs, linters, and formatters. [mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) automates tool installation for easy setup migration.
```lua
return {
  "williamboman/mason.nvim",
  config = true,
  dependencies = {
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = {
        ensure_installed = {
          "lua_ls",
          "clangd",
          "typescript-language-server",
          "stylua",
          "clang-format",
          "prettier",
          "eslint_d",
          "codelldb",
          "js-debug-adapter"
        },
        auto_update = true,
        run_on_start = true,
        start_delay = 1000,
      },
      dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "jay-babu/mason-null-ls.nvim"
      }
    }
  }
}
```

### lspconfig
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) provides preconfigured LSP setups for standard features.
```lua
return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp"
  },
  keys = {
    { "gd", vim.lsp.buf.definition, { silent = true } },
    { "gr", vim.lsp.buf.references },
    { "K", vim.lsp.buf.hover },
    { "<leader>r", function(replace_with) vim.lsp.buf.rename(replace_with) end }
  },
  config = function()
    local default_capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    vim.lsp.config("lua_ls", {
      capabilities = default_capabilities
    })

    vim.lsp.config("clangd", {
      capabilities = default_capabilities,
      cmd = { "clangd", "--background-index", "--log=verbose" },
    })

    vim.lsp.config("ts_ls", {
      capabilities = default_capabilities
    })

    vim.lsp.enable({"ts_ls", "lua_ls", "clangd"})
  end
}
```

### Treesitter
[Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) generates real-time syntax trees for code, enabling features like syntax highlighting.
```lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "vimdoc",
      "markdown",
      "markdown_inline",
      "bash",
      "lua",
      "c",
      "cpp",
      "make",
      "cmake",
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "prisma",
      "http",
      "json",
      "graphql",
      "editorconfig",
      "gitignore"
    },
    auto_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    }
  }
}
```

### Telescope
[Telescope](https://github.com/nvim-telescope/telescope.nvim) is a highly customizable fuzzy finder for:
* Opening files
* Navigating buffers
* Searching code
* Browsing Git files
* Searching help tags
```lua
return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  opts = {
    pickers = {
      find_files = {
        find_command = { "rg", "--files", "--color", "never", "--no-require-git" }
      }
    }
  },
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end },
    { "<leader>fa", function() require("telescope.builtin").find_files({ follow = true, no_ignore = true, hidden = true }) end },
    { "<leader>fg", function() require("telescope.builtin").git_files() end },
    { "<leader>fw", function() require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") }) end },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end },
    { "<Tab>", function() require("telescope.builtin").buffers() end },
  }
}
```

### Code Formatting
Use [Conform](https://github.com/stevearc/conform.nvim) for code formatting. Adjust formatters based on your file types.
```lua
return {
  {
    "windwp/nvim-autopairs",
    opts = {
      map_cr = true
    }
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        { lua = "stylua" },
        { c = "clang-format" },
        { cpp = "clang-format" },
        { cmake = "cmake-format" },
        { html = "prettier" },
        { css = "prettier" },
        { javascript = "prettier" },
        { typescript = "prettier" },
        { tsx = "prettier" },
        { prisma = "prisma" },
        { json = "prettier" },
        { graphql = "prettier" },
        { markdown = "prettier" },
        { markdown_inline = "prettier" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      }
    },
    keys = {
      { "<leader>i", function() require("conform").format({ async = true, lsp_fallback = true }) end }
    }
  }
}
```

### Code Suggestions
Use [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) for code completion and snippets.
```lua
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip"
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-c>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(
          function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
          { "i", "s" }),
      }),
      sources = cmp.config.sources(
        {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
        {
          { name = "buffer" },
        }),
    })
  end,
}
```

### Debugging
Use [nvim-dap](https://github.com/mfussenegger/nvim-dap) for debugging protocols and [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) for a visual interface.
```lua
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    { "<leader>dd", function() require("dapui").toggle({}) end },
    { "<leader>db", function() require("dap").toggle_breakpoint() end },
    { "<F5>",       function() require("dap").continue() end },
    { "<F6>",       function() require("dap").step_into() end },
    { "<F7>",       function() require("dap").step_over() end },
    { "<F8>",       function() require("dap").step_out() end },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("plugins.dap-typescript").setup(dap)
    require("plugins.dap-c").setup(dap)

    dapui.setup()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end
}
```

#### plugins/dap/typescript.lua
```lua
return {
  setup = function(dap)
    local debug_adapter_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

    for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "pwa-extensionHost" }) do
      dap.adapters[adapter] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            debug_adapter_path,
            "${port}"
          },
        },
      }
    end

    for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        }
      }
    end
  end
}
```

#### plugins/dap/c.lua
```lua
return {
  setup = function(dap)
    local debugger_path = vim.fn.exepath("codelldb")

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = debugger_path,
        args = { "--port", "${port}" },
      }
    }

    for _, language in ipairs({ "c", "cpp" }) do
      dap.configurations[language] = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            local exe_path = vim.fn.glob(vim.fn.getcwd() .. "/build/*") or vim.fn.glob(vim.fn.getcwd() .. "/bin/*")
            if exe_path ~= "" then
              return exe_path
            else
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
            end
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {}
        },
      }
    end
  end
}
```
