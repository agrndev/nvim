return {
  setup = function()
    local dap = require("dap")
    local debugger_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg"

    dap.adapters.coreclr = {
      type = 'executable',
      command = debugger_path .. '/netcoredbg',
      args = {'--interpreter=vscode'}
    }

    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
          local dll_path = vim.fn.glob(vim.fn.getcwd() .. "/bin/Debug/*/*.dll")
          if dll_path ~= "" then
            return dll_path
          else
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end
        end,
      },
    }
  end
}

