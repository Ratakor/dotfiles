{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    formatter = config.treefmt.build.wrapper;

    # https://flake.parts/options/treefmt-nix.html
    treefmt = {
      projectRootFile = "flake.nix";
      enableDefaultExcludes = true;

      settings = {
        global.excludes = [
          "*.age"
          ".envrc"
          # "*.diff"
        ];
      };

      # https://github.com/numtide/treefmt-nix#supported-programs
      programs = {
        # nix
        alejandra.enable = true;
        deadnix = {
          enable = false; # I don't want it to make changes
          no-lambda-pattern-names = true;
        };
        statix = {
          enable = false; # I don't want it to make changes
          disabled-lints = []; # see `statix list`
        };

        # lua
        stylua = {
          enable = true;
          settings = {
            call_parentheses = "Always";
            collapse_simple_statement = "Never";
            column_width = 120; # try to stay between 80 and 100 though
            indent_type = "Spaces";
            indent_width = 4;
            line_endings = "Unix";
            quote_style = "AutoPreferDouble";
            sort_requires.enabled = true;
          };
        };

        # python
        black.enable = true;

        # shell
        shfmt = {
          enable = true;
          indent_size = null; # n for spaces, 0 for tabs, null for .editorconfig
        };
        shellcheck.enable = true;

        # js / css / html / markdown
        prettier = {
          enable = false; # I don't see its use atm
          package = pkgs.prettierd;
          settings = {
            editorconfig = true;
            # rest of settings ...
          };
        };

        # english
        typos = {
          enable = false; # TODO: use in pre-commit / CI instead, same for statix/deadnix (& shellcheck?)
          locale = "en-us";
        };
      };
    };
  };
}
