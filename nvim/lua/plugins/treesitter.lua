return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  lazy = false,
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "c",
      "c_sharp",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "rust",
      "vim",
      "vimdoc",
      "zig",
    },
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 100 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          vim.notify("Treesitter disabled")
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
    }
  }
}
