{ inputs, pkgs, ... }:

{
  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        autocomplete = {
          blink-cmp = {
            enable = true;
            friendly-snippets.enable = true;
            setupOpts = {
              keymap.preset = "default";
              signature = { enable = true; window = { show_documentation = false; }; };
              completion = { documentation = { auto_show = true; }; };
            };
            sourcePlugins = {
              lazydev = {
                enable = true;
                package = "lazydev-nvim";
                module = "lazydev.integrations.blink";
              };
            };
          };
        };

        clipboard = {
          enable = true;
          registers = "unnamedplus";
        };

	telescope.enable = true;

	mini.statusline.enable = true;
	mini.pairs.enable = true;
        mini.icons.enable = true;

	theme = {
	  enable = true;
	  name = "tokyonight";
	  style = "night";
	};

	options = {
	  breakindent = true;
	  confirm = true;
	  cursorline = true;
	  expandtab = true;
	  ignorecase = true;
	  inccommand = "split";
	  list = true;
	  number = true;
	  relativenumber = true;
	  scrolloff = 999;
	  shiftwidth = 4;
	  showmode = false;
	  signcolumn = "yes";
	  smartcase = true;
	  softtabstop = -1;
	  swapfile = false;
	  termguicolors = true;
	  timeoutlen = 500;
	  undofile = true;
	};

        languages = {
	  enableDAP = false;
	  enableTreesitter = true;
	  enableFormat = true;

	  css = {
	    enable = true;
	    format = {
	      enable = true;
	      package = pkgs.prettierd;
	    };
	  };
	  ts = {
	    enable = true;
	    format = {
	      enable = true;
	      package = pkgs.prettierd;
	    };
	  };
	  html.enable = true;
	  java.enable = true;
	  lua.enable = true;
	  nix.enable = true;
	  python.enable = true;
	  rust.enable = true;
	  zig.enable = true;
          bash.enable = true;
          clang.enable = true;
	};

	lsp.enable = true;

        utility.oil-nvim = {
          enable = true;
          setupOpts = {
            columns = [ "icon" ];
            constrain_cursor = "editable";
            watch_for_changes = true;
            keymaps = {
              "<C-h>" = false;
              "<C-l>" = false;
            };
            view_options = {
              show_hidden = true;
            };
          };
        };
      };
    };
  };
}
