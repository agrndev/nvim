return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "vimdoc",
      "gitignore",
      "editorconfig",
    },
    highlight = { enable = true },
    indent = { enable = true },
  }
}
