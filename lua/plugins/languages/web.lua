return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function()
      vim.lsp.config("html", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        filetypes = {
          "html",
        },
      })

      vim.lsp.config("cssls", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        filetypes = {
          "css",
        },
      })

      vim.lsp.enable({ "html", "cssls" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "html-lsp",
        "css-lsp",
        "prettier",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "html",
        "css",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
         html = { "prettier" },
         css = { "prettier" },
      },
    },
  },
}

