return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    { "<leader>dd", function() require("dapui").toggle({}) end },
    { "<leader>db", function() require("dap").toggle_breakpoint() end },
    { "<F5>",       function() require("dap").continue() end },
    { "<F6>",       function() require("dap").step_into() end },
    { "<F7>",       function() require("dap").step_over() end },
    { "<F8>",       function() require("dap").step_out() end },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end
}
