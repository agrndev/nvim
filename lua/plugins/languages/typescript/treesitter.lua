return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  opts = {
    ensure_installed = {
      "javascript",
      "typescript",
      "tsx",
      "prisma",
      "json",
      "graphql",
    }
  }
}
