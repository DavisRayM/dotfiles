{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  programs.neovim = {
    extraLuaConfig = ''
      local statusline = require 'mini.statusline'
      statusline.section_location = function()
        return '%2l|%-2v'
      end
    '';
  };

  # TODO: Split this into imports at some point...
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
              signature = {
                enable = true;
                window = {show_documentation = false;};
              };
              completion = {documentation = {auto_show = true;};};
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

        notes.todo-comments = {
          enable = true;
          setupOpts = {
            signs = false;
          };
        };

        diagnostics = {
          enable = true;
          config = {
            severity_sort = true;
            float = {
              border = "rounded";
              source = "if_many";
            };
            virtual_text = {
              source = "if_many";
              spacing = 2;
              format = lib.generators.mkLuaInline ''
                function(diagnostic)
                  return diagnostic.message
                end
              '';
            };
            underline = lib.generators.mkLuaInline ''
              { severity = vim.diagnostic.severity.ERROR }
            '';
            signs = {
              text = lib.generators.mkLuaInline ''
                {
                  [vim.diagnostic.severity.ERROR] = "󰅚 ",
                  [vim.diagnostic.severity.WARN] = "󰀪 ",
                  [vim.diagnostic.severity.INFO] = "󰋽 ",
                  [vim.diagnostic.severity.HINT] = "󰌶 ",
                }
              '';
            };
          };
        };

        globals = {
          mapleader = " ";
          maplocalleader = " ";
        };

        git.vim-fugitive.enable = true;

        clipboard = {
          enable = true;
          registers = "unnamedplus";
          providers.wl-copy.enable = true;
        };

        lsp = {
          enable = true;
          formatOnSave = true;
          inlayHints.enable = true;
          lspconfig.enable = true;
          mappings = {
            addWorkspaceFolder = null;
            codeAction = "gra";
            documentHighlight = null;
            format = null;
            goToDeclaration = "grD";
            goToDefinition = null;
            goToType = null;
            hover = null;
            listDocumentSymbols = null;
            listImplementations = null;
            listReferences = null;
            listWorkspaceFolders = null;
            listWorkspaceSymbols = null;
            nextDiagnostic = "]d";
            openDiagnosticFloat = "gsd";
            previousDiagnostic = "[d";
            removeWorkspaceFolder = null;
            renameSymbol = "grn";
            signatureHelp = "K";
            toggleFormatOnSave = null;
          };
        };

        telescope = {
          enable = true;
          mappings = {
            buffers = "<leader>sb";
            diagnostics = null;
            findFiles = "<leader>sf";
            findProjects = null;
            gitBranches = null;
            gitBufferCommits = null;
            gitCommits = null;
            gitStash = null;
            gitStatus = null;
            helpTags = "<leader>sh";
            liveGrep = "<leader>sg";
            lspDocumentSymbols = "gO";
            lspImplementations = "gri";
            lspReferences = "grr";
            lspTypeDefinitions = "grt";
            lspWorkspaceSymbols = "gW";
            open = null;
            resume = "<leader>sr";
            treesitter = null;
          };
          setupOpts = {
            pickers = {
              buffers.theme = "ivy";
              find_files.theme = "ivy";
              help_tags.theme = "ivy";
              quickfix.theme = "ivy";
              grep_string.theme = "ivy";
            };
          };
        };

        mini.statusline = {
          enable = true;
          setupOpts = {
            use_icons = true;
          };
        };
        mini.pairs.enable = true;
        mini.icons.enable = true;

        # theme = {
        #   enable = true;
        #   name = "tokyonight";
        #   style = "night";
        # };

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

        utility.oil-nvim = {
          enable = true;
          setupOpts = {
            columns = ["icon"];
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

        binds = {
          whichKey = {
            enable = true;
          };
        };

        keymaps = [
          {
            key = "<leader>gs";
            mode = "n";
            action = "<cmd>Git<CR>";
          }
          {
            key = "-";
            mode = "n";
            action = "<cmd>Oil<CR>";
          }
          {
            key = "<Esc>";
            mode = "n";
            action = "<cmd>nohlsearch<CR>";
          }
          {
            key = "<Esc><Esc>";
            mode = "t";
            action = "<C-\\><C-n>";
          }
          {
            key = "<left>";
            mode = "n";
            action = "<cmd>echo 'Disabled'<CR>";
          }
          {
            key = "<right>";
            mode = "n";
            action = "<cmd>echo 'Disabled'<CR>";
          }
          {
            key = "<up>";
            mode = "n";
            action = "<cmd>echo 'Disabled'<CR>";
          }
          {
            key = "<down>";
            mode = "n";
            action = "<cmd>echo 'Disabled'<CR>";
          }
          {
            key = "<C-h>";
            mode = "n";
            action = "<C-w><C-h>";
          }
          {
            key = "<C-l>";
            mode = "n";
            action = "<C-w><C-l>";
          }
          {
            key = "<C-j>";
            mode = "n";
            action = "<C-w><C-j>";
          }
          {
            key = "<C-k>";
            mode = "n";
            action = "<C-w><C-k>";
          }
        ];
      };
    };
  };
}
