return {
  "williamboman/mason.nvim",
  config = function ()
    require("mason").setup({
      -- Roslyn C# LSP
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      }
    })
  end,
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
          "csharpier",
          "prettier",
          "eslint_d",
          "codelldb",
          "netcoredbg",
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
