vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.8',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'rose-pine/neovim'

  use {
	  'nvim-treesitter/nvim-treesitter',
	  run = function()
		  local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
		  ts_update()
	  end,
  }

  use {
      'folke/todo-comments.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
          require('todo-comments').setup {}
      end
  }

  use {
      'notjedi/nvim-rooter.lua',
      config = function() require'nvim-rooter'.setup() end
  }

  use {
      'itchyny/lightline.vim',
      lazy = false, -- also load at start since it's UI
      config = function()
          vim.o.showmode = false
          vim.g.lightline = {
              active = {
                  left = {
                      { 'mode', 'paste' },
                      { 'readonly', 'filename', 'modified' }
                  },
                  right = {
                      { 'lineinfo' },
                      { 'fileencoding', 'filetype' }
                  },
              },
              component_function = {
                  filename = 'LightlineFilename'
              },
          }
          function LightlineFilenameInLua(opts)
              if vim.fn.expand('%:t') == '' then
                  return '[No Name]'
              else
                  return vim.fn.getreg('%')
              end
          end
          -- https://github.com/itchyny/lightline.vim/issues/657
          vim.api.nvim_exec(
          [[
          function! g:LightlineFilename()
          return v:lua.LightlineFilenameInLua()
          endfunction
          ]],
          true
          )
      end
  }

  use 'theprimeagen/harpoon'

  use 'mbbill/undotree'

  use 'tpope/vim-fugitive'

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/nvim-cmp'

  use {
      "ray-x/lsp_signature.nvim",
      opts = {},
      config = function(_, opts)
          -- Get signatures (and _only_ signatures) when in argument lists.
          require "lsp_signature".setup({
              doc_lines = 0,
              handler_opts = {
                  border = "none"
              },
          })
      end
  }

  -- LSP
  use 'elkowar/yuck.vim'
  use {
      'rust-lang/rust.vim',
      ft = { "rust" },
      config = function()
          vim.g.rustfmt_autosave = 1
          vim.g.rustfmt_emit_files = 1
          vim.g.rustfmt_fail_silently = 0
          vim.g.rust_clip_command = 'wl-copy'
      end
  }
  use 'khaveesh/vim-fish-syntax'
  use {
		'plasticboy/vim-markdown',
		ft = { "markdown" },
		requires = {
			'godlygeek/tabular',
		},
		config = function()
			-- never ever fold!
			vim.g.vim_markdown_folding_disabled = 1
			-- support front-matter in .md files
			vim.g.vim_markdown_frontmatter = 1
			-- 'o' on a list item should insert at same level
			vim.g.vim_markdown_new_list_item_indent = 0
			-- don't add bullets when wrapping:
			-- https://github.com/preservim/vim-markdown/issues/232
			vim.g.vim_markdown_auto_insert_bullets = 0
		end
	}
    use {
        "cuducos/yaml.nvim",
        ft = { "yaml" },
        requires = {
            "nvim-treesitter/nvim-treesitter",
        },
    }

    -- Vimwiki
    use 'vimwiki/vimwiki'
end)
