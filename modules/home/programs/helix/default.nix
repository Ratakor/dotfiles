{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.modules) mkIf;
  inherit (self.lib.trivial) unreachable;

  langAttrsToList = mapAttrsToList (name: conf: { inherit name; } // conf);
in
{
  # - $EDITOR
  # - mimeapps.list
  # - ~zsh mode~
  # - ~vimium~

  config = mkIf (config.self.editor.program == "helix") {
    self.editor = {
      cmd = "hx";
      desktopEntry = "Helix.desktop";
    };

    hm.programs.helix = {
      enable = true;

      extraPackages = with pkgs; [
        # Language servers
        bash-language-server # Bash
        clang-tools # C/C++
        vscode-css-languageserver # CSS
        gopls # Go
        jdt-language-server # Java
        python313Packages.jedi-language-server # Python
        lua-language-server # Lua
        marksman # Markdown
        # nixd # Nix
        nil # Nix
        ocamlPackages.ocaml-lsp # OCaml
        rust-analyzer # Rust
        sqls # SQL
        superhtml # HTML
        taplo # TOML
        texlab # LaTeX
        vscode-json-languageserver # JSON
        vtsls # JS/TS
        yaml-language-server # YAML
        zls # Zig

        # Formatters
        black # Python
        nixfmt # Nix
        ocamlPackages.ocamlformat # OCaml

        # Toolchains (often needed by language servers)
        cargo
        zig

        self.pkgs.scooter-wrapped # interactive find-and-replace
      ];

      settings = {
        # inherit (config.self.colors.helix) theme;
        theme = "transparent";

        # https://docs.helix-editor.com/editor.html
        editor = {
          scrolloff = 0;
          # default-yank-register = "+"; # "+y / "+p / <space>y / <space>p
          middle-click-paste = false;
          line-number = "relative";
          continue-comments = false;
          # auto-format = false;
          rulers = [
            80
            100
          ];
          # bufferline = "multiple";
          color-modes = true;
          text-width = 80; # gq is :reflow or zq
          trim-final-newlines = true;
          trim-trailing-whitespace = true;
          end-of-line-diagnostics = "hint"; # error, warning, info, hint

          # This is almost the same as default
          statusline = {
            left = [
              "mode"
              "spinner"
              # "version-control"
              "file-name"
              "read-only-indicator"
              "file-modification-indicator"
            ];
            center = [ ];
            right = [
              "diagnostics"
              "selections"
              "register"
              # "position-percentage"
              "position"
              "file-encoding"
              "file-type"
            ];
            separator = "│";
            mode.normal = "NORMAL";
            mode.insert = "INSERT";
            mode.select = "SELECT";
            diagnostics = [
              "warning"
              "error"
            ];
            workspace-diagnostics = [
              "warning"
              "error"
            ];
          };

          cursor-shape = {
            insert = "bar";
          };

          # auto-pairs = false;

          whitespace = {
            render = {
              space = "all";
              tab = "all";
            };
            characters = {
              space = "·";
              tab = "|";
              # newline = "$"; # ↴
            };
          };

          inline-diagnostics = {
            # see end-of-line-diagnostics
            cursor-line = "disable";
            other-lines = "disable";
          };
        };

        # https://docs.helix-editor.com/keymap.html
        # https://docs.helix-editor.com/remapping.html
        # https://docs.helix-editor.com/commands.html
        # g [ ] m " z <space>
        keys =
          let
            shared = {
              z.q = ":reflow";
              x = "select_line_below"; # default: extend_line_below
              X = "select_line_above";
              space = {
                space = ":format";
                # reverse f/F and e/E
                f = "file_picker_in_current_directory";
                F = "file_picker";
                e = "file_explorer_in_current_buffer_directory";
                E = "file_explorer";
                # replace workspace_symbol_picker with interactive find-and-replace
                S = [
                  ":pipe scooter --print-on-exit >/dev/tty"
                  ":redraw"
                  # ":write-all"
                  # ":insert-output scooter --no-stdin >/dev/tty"
                  # ":redraw"
                  # ":reload-all"
                ];
              };
              "C-h" = "select_prev_sibling";
              "C-j" = "shrink_selection";
              "C-k" = "expand_selection";
              "C-l" = "select_next_sibling";
            };
          in
          {
            normal = shared // {
              esc = [
                "collapse_selection" # ;
                "keep_primary_selection" # ,
              ];
            };
            select = shared;
          };
      };

      languages = {
        # https://github.com/helix-editor/helix/blob/master/languages.toml
        # https://github.com/helix-editor/helix/wiki/Formatter-Configurations
        language = langAttrsToList {
          c = {
            indent = {
              tab-width = 8;
              unit = "\t";
            };
          };
          nix = {
            formatter = {
              command = "nixfmt";
            };
            auto-format = true;
          };
          python = {
            formatter = {
              command = "black";
              args = [
                "--quiet"
                "-"
              ];
            };
            auto-format = true;
          };
        };
      };

      # https://docs.helix-editor.com/themes.html
      # https://github.com/helix-editor/helix/tree/master/runtime/themes
      themes = {
        transparent = {
          inherits = config.self.colors.helix.theme;
          "ui.background" = "none";
          "function" = {
            fg =
              if config.self.colorscheme == "gruvbox-dark" || config.self.colorscheme == "gruvbox-light" then
                "green1"
              else if config.self.colorscheme == "dracula" then
                "green"
              else
                unreachable;
            modifiers = [ "bold" ];
          };
        };
      };
    };
  };
}
