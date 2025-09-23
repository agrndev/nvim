return {
  setup = function(dap)
    local debug_adapter_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

    for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "pwa-extensionHost", }) do
      dap.adapters[adapter] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            debug_adapter_path,
            "${port}"
          },
        },
      }
    end

    for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        }
      }
    end
  end
}
