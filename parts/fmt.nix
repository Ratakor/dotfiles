{ self, sources }:
pkgs:
let
  treefmt = (import sources.treefmt-nix).evalModule pkgs {
    projectRootFile = "flake.nix";
    enableDefaultExcludes = true;

    settings = {
      global.excludes = [
        "*.age"
        "*.diff"
      ];
    };

    # https://github.com/numtide/treefmt-nix#supported-programs
    programs = {
      # nix
      nixfmt.enable = true;
      deadnix = {
        enable = false; # I don't want it to make changes
        no-lambda-pattern-names = true;
      };
      statix = {
        enable = false; # I don't want it to make changes
        disabled-lints = [ ]; # see `statix list`
      };

      # lua
      stylua = {
        enable = true;
        settings = {
          call_parentheses = "Always";
          collapse_simple_statement = "Never";
          column_width = 120; # try to stay between 80 and 100 though
          indent_type = "Spaces";
          indent_width = 2;
          line_endings = "Unix";
          quote_style = "AutoPreferDouble";
          sort_requires.enabled = true;
        };
      };

      # python
      ruff-format.enable = true;

      # shell
      shfmt = {
        enable = true;
        indent_size = null; # n for spaces, 0 for tabs, null for .editorconfig
      };
      shellcheck = {
        enable = true;
        includes = [
          "*.sh"
          "*.bash"
        ];
      };

      # js / css / html / markdown
      prettier = {
        enable = false; # I don't see its use atm
        package = pkgs.prettierd;
        settings = {
          editorconfig = true;
          # rest of settings ...
        };
      };

      # zig
      zig.enable = true;

      # toml
      taplo = {
        enable = true;
        settings.formatting = {
          inline_table_expand = false;
          compact_arrays = false;
          align_comments = false;
        };
      };

      # english
      # TODO: too much false positive and I cba config
      # use in pre-commit / CI instead?
      # same for statix/deadnix
      typos = {
        enable = false;
        # configFile = toml.generate "typos-config.toml" { };
        # locale = null;
        # includes = [ "*.nix" ];
        excludes = [
          "**/emoji"
          # "*.lua"
          # "*.zig"
        ];
      };
    };
  };
in
{
  formatter = treefmt.config.build.wrapper;
  check = treefmt.config.build.check self;
}
