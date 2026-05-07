return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug breakpoint" },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Debug conditional breakpoint",
      },
      {
        "<leader>dl",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        desc = "Debug log point",
      },
      { "<leader>dc", function() require("dap").run_to_cursor() end, desc = "Debug to cursor" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug UI" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Debug terminate" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local mason_nvim_dap = require("mason-nvim-dap")

      vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticSignHint", linehl = "", numhl = "" })

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.5 },
              { id = "breakpoints", size = 0.2 },
              { id = "stacks", size = 0.15 },
              { id = "watches", size = 0.15 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      require("nvim-dap-virtual-text").setup({
        commented = true,
        highlight_changed_variables = true,
        show_stop_reason = true,
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
      })

      local ui_open = function()
        dapui.open()
      end

      local ui_close = function()
        dapui.close()
      end

      dap.listeners.before.attach.dapui_config = ui_open
      dap.listeners.before.launch.dapui_config = ui_open
      dap.listeners.before.event_terminated.dapui_config = ui_close
      dap.listeners.before.event_exited.dapui_config = ui_close

      mason_nvim_dap.setup({
        ensure_installed = { "codelldb", "python" },
        automatic_installation = true,
        handlers = {
          function(config)
            mason_nvim_dap.default_setup(config)
          end,
          python = function(config)
            config.configurations = {
              {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
                console = "integratedTerminal",
                pythonPath = function()
                  return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python"
                end,
              },
            }
            mason_nvim_dap.default_setup(config)
          end,
          codelldb = function(config)
            config.configurations = {
              {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
              },
            }
            mason_nvim_dap.default_setup(config)
          end,
        },
      })
    end,
  },
}
