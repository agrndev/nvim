return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function()
      vim.lsp.config("bashls", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash" },
        root_markers = {
          ".git",
          ".bashrc",
          ".bash_profile",
        },
      })

      vim.lsp.enable("bashls")
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server",
        "shfmt",
        "shellcheck",
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        { sh = "shfmt" },
        { bash = "shfmt" },
      },
    },
  },
}
