# Subset of my own helix config but wrapped
# As of 18 Sep 2025 the differences are:
# - no languages settings
# - no custom themes
# - default theme is gruvbox
{
  lib,
  pkgs,
  helix,
  symlinkJoin,
  makeWrapper,
  extraPackages ? with pkgs; [
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
  ],
}:
let
  inherit (lib.strings) makeBinPath;

  toml = pkgs.formats.toml { };

  settings = {
    # https://github.com/helix-editor/helix/tree/master/runtime/themes
    theme = "gruvbox";

    # https://docs.helix-editor.com/editor.html
    editor = {
      scrolloff = 0;
      # default-yank-register = "+"; # "+y / "+p
      middle-click-paste = false;
      line-number = "relative";
      continue-comments = false;
      # auto-format = false;
      # bufferline = "multiple";
      color-modes = true;
      text-width = 80; # gq is :reflow or zq
      trim-final-newlines = true;
      trim-trailing-whitespace = true;
      end-of-line-diagnostics = "hint"; # error, warning, info, hint

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
        z.q = ":reflow";
        X = "extend_line_above";
      };
      select = {
        z.q = ":reflow";
        X = "extend_line_above";
      };
    };
  };
in
symlinkJoin {
  inherit (helix) pname version meta;
  paths = [ helix ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/hx \
      --suffix PATH : ${makeBinPath extraPackages} \
      --add-flag "--config" \
      --add-flag ${toml.generate "helix-config.toml" settings}
  '';
}
