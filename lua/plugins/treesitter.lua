return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = {
        "vimdoc",
        "markdown",
        "markdown_inline",
        "bash",
        "lua",
        "c",
        "cpp",
        "make",
        "cmake",
        "c_sharp",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "prisma",
        "http",
        "json",
        "graphql",
        "editorconfig",
        "gitignore"
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      }
    }
  end
}

