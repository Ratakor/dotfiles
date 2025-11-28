# Subset of my own helix config but wrapped
# As of 04 Oct 2025 the differences are:
# - no languages settings
# - no custom themes
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
    jdt-language-server # Java
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

    # Toolchains (often needed by language servers)
    cargo
    zig

    scooter-wrapped # interactive find-and-replace
  ],
  # dark: gruvbox dracula
  # light: gruvbox_light acme papercolor-light
  theme ? "gruvbox",
}:
let
  inherit (lib.strings) makeBinPath;

  toml = pkgs.formats.toml { };

  settings = {
    inherit theme;

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
