return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    { '<leader>ds', function() require('dap').continue() end,          desc = "[D]ebug: [S]tart/Continue" },
    { '<leader>di', function() require('dap').step_into() end,         desc = "[D]ebug: [S]tep Into" },
    { '<leader>do', function() require('dap').step_over() end,         desc = "[D]ebug: [S]tep Over" },
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = "[D]ebug: [S]et breakpoint" },
    { '<leader>dt', function() require('dapui').toggle() end,          desc = "[D]ebug: [T]oggle UI" },
  },
  config = function()
    local dap = require 'dap';
    local dapui = require 'dapui';

    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- [[ Adapters ]]
    dap.adapters.codelldb = {
      type = 'server',
      port = "${port}",
      executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
      }
    }

    -- [[ Configurations ]]
    dap.configurations.c = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }

    dap.configurations.zig = dap.configurations.c
    dap.configurations.rust = dap.configurations.c
    dap.configurations.cpp = dap.configurations.c
  end
}
