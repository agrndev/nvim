return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    keys = {
      { "gd", vim.lsp.buf.definition, { silent = true } },
      { "gr", vim.lsp.buf.references },
      { "K", vim.lsp.buf.hover },
      { "<leader>r", vim.lsp.buf.rename },
    },
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            }
          }
        }
      }
    },
    config = function(_, opts)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      for server, server_opts in pairs(opts.servers) do
        server_opts.capabilities = vim.tbl_deep_extend(
          "force",
          {},
          capabilities,
          server_opts.capabilities or {}
        )
        vim.lsp.config(server, server_opts)
      end
    end
  }
}
