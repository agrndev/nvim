return {
  "nvim-treesitter/nvim-treesitter",
  tag = "v0.10.0",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "vimdoc",
      "lua",
      "make",
      "cmake",
      "editorconfig",
      "gitignore"
    },
    highlight = { enable = true },
    indent = { enable = true },
  }
}
