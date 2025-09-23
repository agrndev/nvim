return {
  setup = function(dap)
    local debugger_path = vim.fn.exepath("codelldb")

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = debugger_path,
        args = { "--port", "${port}" },
      }
    }

    for _, language in ipairs({ "c", "cpp" }) do
      dap.configurations[language] = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            local exe_path = vim.fn.glob(vim.fn.getcwd() .. "/build/*") or vim.fn.glob(vim.fn.getcwd() .. "/bin/*")
            if exe_path ~= "" then
              return exe_path
            else
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
            end
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {}
        },
      }
    end
  end
}
