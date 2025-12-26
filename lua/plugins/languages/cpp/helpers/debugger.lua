-- return {
--   {
--     "mfussenegger/nvim-dap",
--     config = function()
--       local dap = require("dap")
--
--       local debugger_path = vim.fn.exepath("codelldb")
--
--       dap.adapters.codelldb = {
--         type = "server",
--         port = "${port}",
--         executable = {
--           command = debugger_path,
--           args = { "--port", "${port}" },
--         },
--       }
--
--       for _, language in ipairs({ "c", "cpp" }) do
--         dap.configurations[language] = {
--           {
--             name = "Launch",
--             type = "codelldb",
--             request = "launch",
--             program = function()
--               local exe =
--                 vim.fn.glob(vim.fn.getcwd() .. "/build/*")
--                 or vim.fn.glob(vim.fn.getcwd() .. "/bin/*")
--
--               if exe ~= "" then
--                 return exe
--               end
--
--               return vim.fn.input(
--                 "Path to executable: ",
--                 vim.fn.getcwd() .. "/build/",
--                 "file"
--               )
--             end,
--             cwd = "${workspaceFolder}",
--             stopOnEntry = false,
--             args = {},
--           },
--         }
--       end
--     end,
--   },
-- }

local function setup(dap)
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = vim.fn.exepath("codelldb"),
      args = { "--port", "${port}" },
    },
  }

  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        local exe = vim.fn.glob(vim.fn.getcwd() .. "/build/*")
          or vim.fn.glob(vim.fn.getcwd() .. "/bin/*")
        if exe ~= "" then
          return exe
        else
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
        end
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
    },
  }
end

return setup
