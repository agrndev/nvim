return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  opts = {
    pickers = {
      find_files = {
        find_command = { "rg", "--files", "--color", "never", "--no-require-git" }
      }
    }
  },
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end },
    { "<leader>fa", function() require("telescope.builtin").find_files({ follow = true, no_ignore = true, hidden = true }) end },
    { "<leader>fg", function() require("telescope.builtin").git_files() end },
    { "<leader>fw", function() require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") }) end },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end },
    { "<Tab>", function() require("telescope.builtin").buffers() end },
  }
}
