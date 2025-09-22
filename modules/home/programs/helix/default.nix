{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets) mapAttrsToList;

  langAttrsToList = mapAttrsToList (name: conf: { inherit name; } // conf);
in
{
  # see helix-zsh / zsh-helix-mode for zsh integration
  # idk what to do for vimium

  hm.programs.helix = {
    enable = true;

    extraPackages = with pkgs; [
      # Language servers
      bash-language-server # Bash
      clang-tools # C/C++
      vscode-css-languageserver # CSS
      gopls # Go
      python313Packages.jedi-language-server # Python
      lua-language-server # Lua
      marksman # Markdown
      # nixd # Nix
      nil # Nix
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
      nixfmt # Nix
      black # Python
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
      keys = {
        normal = {
          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];
          space = {
            w = ":write";
            q = ":quit";
          };
          z.q = ":reflow";
          X = "extend_line_above";
          "C-h" = "select_prev_sibling";
          "C-j" = "shrink_selection";
          "C-k" = "expand_selection";
          "C-l" = "select_next_sibling";
        };
        select = {
          z.q = ":reflow";
          X = "extend_line_above";
        };
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
          modifiers = [ "bold" ];
        };
      };
    };
  };
}
