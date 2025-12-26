return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      { javascript = "prettier" },
      { typescript = "prettier" },
      { tsx = "prettier" },
      { prisma = "prisma" },
      { json = "prettier" },
      { graphql = "prettier" }
    }
  }
}
