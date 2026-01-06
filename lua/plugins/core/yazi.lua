return {
  "mikavilpas/yazi.nvim",
  lazy = false,
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    { "<leader>pv", mode = { "n", "v" }, "<cmd>Yazi<cr>", },
  },
  config = function()
    require("yazi").setup({
      open_for_directories = false,
      floating_window_scaling_factor = 1.0,
      yazi_floating_window_border = "none",
      keymaps_in_yazi_for_directory_buffer = {
        ["<tab>"] = "toggle",
      },
    })

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        local arg = vim.fn.argv(0)
        if arg ~= "" then
          local stat = vim.loop.fs_stat(arg)
          if stat and stat.type == "directory" then
            vim.cmd("bdelete")
            require("yazi").yazi(nil, arg)
          end
        end
      end,
    })
  end,
  init = function()
    vim.g.loaded_netrwPlugin = 1
  end
}
