return {
  {
    "neovim/nvim-lspconfig",
     dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function()
      vim.lsp.config("markdown", {
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      })

      vim.lsp.enable("markdown")
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "marksman",
        "markdownlint",
        "prettier"
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline"
     },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "prettier" },
      }
    }
  },
  {
    "iamcco/markdown-preview.nvim",
    lazy = true,
    ft = { "markdown" },
    build = "cd app && npm install",
    config = function()
      vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<cr>", { desc = "Markdown Preview" })
      vim.keymap.set("n", "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", { desc = "Markdown Preview Stop" })
    end,
  }
}

