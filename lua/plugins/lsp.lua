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
