return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim"
    },
    keys = {
      { "gd", vim.lsp.buf.definition, { silent = true } },
      { "gr", vim.lsp.buf.references },
      { "K", vim.lsp.buf.hover },
      { "<leader>r", vim.lsp.buf.rename },
      { "<leader>a", vim.lsp.buf.code_action },
    },
    config = function()
      require("mason").setup()
    end
  }
}
