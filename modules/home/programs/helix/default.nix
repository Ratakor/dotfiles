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

  hm.programs.helix = {
    enable = true;

    extraPackages = with pkgs; [
      # Language servers
      # https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
      bash-language-server # bashls (Bash)
      clang-tools # clangd (C/C++)
      vscode-css-languageserver # cssls (CSS)
      gopls # gopls (Go)
      python313Packages.jedi-language-server # jedi_language_server (Python)
      lua-language-server # lua_ls (Lua)
      marksman # marksman (Markdown)
      # nixd # nixd (Nix)
      nil # nil_ls (Nix)
      rust-analyzer # rust_analyzer (Rust)
      sqls # sqls (SQL)
      superhtml # superhtml (HTML)
      taplo # taplo (TOML)
      texlab # texlab (LaTeX)
      vscode-json-languageserver # jsonls (JSON)
      vtsls # vtsls (JS/TS)
      yaml-language-server # yamlls (YAML)
      zls # zls (Zig)

      # Formatters
      nixfmt
    ];

    settings = {
      # https://github.com/helix-editor/helix/tree/master/runtime/themes
      # inherit (config.self.colors.helix) theme;
      theme = "transparent";

      # https://docs.helix-editor.com/editor.html
      editor = {
        scrolloff = 0;
        middle-click-paste = false;
        line-number = "relative";
        continue-comments = false;
        bufferline = "multiple";
        color-modes = true;
        text-width = 80; # gc is :reflow or zr
        trim-final-newlines = true;
        trim-trailing-whitespace = true;
        end-of-line-diagnostics = "hint"; # error, warning, info, hint

        cursor-shape = {
          insert = "bar";
        };

        auto-pairs = false;

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
      keys = {
        normal = {
          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];
          space = {
            w = ":w";
            q = ":q";
          };
          z.r = ":reflow";
        };
        select = {
          z.r = ":reflow";
        };
      };
    };

    languages = {
      # https://github.con/helix-editor/helix/blob/master/languages.toml
      language = langAttrsToList {
        c = {
          indent = {
            tab-width = 8;
            unit = "\t";
          };
        };
      };
    };

    themes = {
      transparent = {
        inherits = config.self.colors.helix.theme;
        "ui.background" = "none";
      };
    };
  };
}
