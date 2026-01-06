return {
  {
    "neovim/nvim-lspconfig",
     dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function()
      vim.lsp.config("lua_ls", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            telemetry = { enable = false },
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
              },
            },
          },
        },
      })

      vim.lsp.enable("lua_ls")
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "lua-language-server",
        "stylua"
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua"
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      }
    }
  },
}
