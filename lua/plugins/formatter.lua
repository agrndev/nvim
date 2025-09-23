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
        { cs = "csharpier" },
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
      { "<leader>i", function() require("conform").format({ async = true, lsp_fallack = true })  end}
    }
  }
}
