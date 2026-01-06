return {
  "nvim-telescope/telescope.nvim",
  tag = "v0.2.0",
  branch = "master",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end },
    { "<leader>fa", function() require("telescope.builtin").find_files({ follow = true, no_ignore = true, hidden = true }) end },
    { "<leader>fg", function() require("telescope.builtin").git_files() end },
    { "<leader>fw", function() require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") }) end },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end },
    { "<Tab>", function() require("telescope.builtin").buffers() end },
    { "<leader>t", function() require("telescope.builtin").colorscheme() end },
  },
  config = function()
    require("telescope").setup({
      pickers = {
        finds_files = {
          find_command = { "rg", "--files", "--color", "never", "--no-require-git" }
        },
        colorscheme = {
          enable_preview = true,
          layout_config = {
            height = 0.25,
            width = 0.35
          }
        }
      }
    })
  end
}
