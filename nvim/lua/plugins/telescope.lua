return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require "telescope"
    local builtin = require "telescope.builtin"
    local themes = require "telescope.themes"

    telescope.setup({
      pickers = {
        buffers = {
          theme = "ivy",
        },
        find_files = {
          theme = "ivy",
        },
        help_tags = {
          theme = "ivy",
        },
        quickfix = {
          theme = "ivy",
        },
        grep_string = {
          theme = "ivy",
        },
      },
    })
    telescope.load_extension("fzf")

    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<Leader>sf", function()
      builtin.find_files { find_command = { "rg", "--files", "--color", "never", "--hidden", "-g", "!.git/" } }
    end, { desc = "[S]each Project [F]iles" })
    vim.keymap.set("n", "<Leader>sg", function()
      require "config.pickers.multigrep".live_grep(themes.get_ivy({}))
    end, { desc = "[S]earch using [G]rep" })
    vim.keymap.set("n", "<Leader>se", function()
      builtin.find_files {
        cwd = vim.fn.stdpath("config"),
      }
    end, { desc = "[S]earch [E]ditor Configurations" })
    vim.keymap.set("n", "<Leader>sd", function()
      builtin.find_files {
        cwd = vim.fn.expand("~/Workspace/dotfiles"),
      }
    end, { desc = "[S]earch [D]otfiles" })
    vim.keymap.set("n", "<Leader>sp", function()
      builtin.find_files {
        cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
      }
    end, { desc = "[S]earch Lazy Installed [P]ackages" })
    vim.keymap.set("n", "<leader>sb", function()
      builtin.buffers { ignore_current_buffer = true }
    end, { desc = "[S]earch [B]uffers" })
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp Tags" })
    vim.keymap.set("n", "<leader>sq", builtin.quickfix, { desc = "[S]earch [Q]uickfix List" })
  end,
}
