return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function()
      vim.lsp.config("clangd", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        cmd = {
          "clangd",
          "--background-index",
          "--log=verbose",
          "--clang-tidy",
          "--header-insertion=iwyu",
        },
        filetypes = { "c", "cpp" },
        root_markers = {
          ".clangd",
          ".clang-format",
          "Makefile",
          ".git",
        },
      })

      vim.lsp.enable("clangd")
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "clangd",
        "clang-format",
        "codelldb",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "make",
        "cmake",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
         c = { "clang-format" },
         cpp = { "clang-format" },
         cmake = { "cmake-format" },
      }
    }
  },
}
