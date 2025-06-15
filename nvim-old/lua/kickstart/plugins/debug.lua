return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "theHamsta/nvim-dap-virtual-text",
  },
  keys = {
    {
      "<leader>dr",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Start/Continue",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<leader>ds",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<leader>du",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
    {
      "<leader>b",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint.",
    },
    {
      "<leader>B",
      function()
        require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end,
      desc = "Debug: Set Conditional Breakpoint.",
    },
    {
      "<leader>dR",
      function()
        require("dap").restart()
      end,
      desc = "Debug: Restart Debugger",
    },
    {
      "<leader>?",
      function()
        require("dapui").eval(nil, { enter = true })
      end,
      desc = "Debug: Eval under cursor",
    },
    {
      "<leader>dt",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: Toggle DAP UI.",
    },
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"

    require("nvim-dap-virtual-text").setup {}
    require("mason-nvim-dap").setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "codellb",
        "cpptools",
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
    vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
    local breakpoint_icons = {
      Breakpoint = "",
      BreakpointCondition = "",
      BreakpointRejected = "",
      LogPoint = "",
      Stopped = "",
    }
    for type, icon in pairs(breakpoint_icons) do
      local tp = "Dap" .. type
      local hl = (type == "Stopped") and "DapStop" or "DapBreak"
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/adapter/codelldb",
        args = { "--port", "${port}" },
      },
    }

    dap.configurations.rust = {
      {
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
      },
    }
  end,
}
