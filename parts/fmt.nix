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
          # "*.diff"
          # ".envrc"
        ];
      };

      # https://github.com/numtide/treefmt-nix#supported-programs
      programs = {
        # nix
        alejandra.enable = true;
        deadnix = {
          enable = false;
          no-lambda-pattern-names = true;
        };
        statix = {
          enable = false;
          disabled-lints = []; # see `statix list`
        };

        # lua
        stylua = {
          enable = true;
          call_parentheses = "Always";
          # collapse_simple_statement = "Always";
          # column_width = 80;
          # indent_type = "Spaces";
          # indent_width = 4;
          # line_endings = "Unix";
          quote_style = "AutoPreferDouble";
          # sort_requires.enabled = true;
        };

        # python
        black.enable = true;

        # shell
        shfmt = {
          enable = true;
          indent_size = null; # n for spaces, 0 for tabs, null for .editorconfig
        };
        shellcheck.enable = true;

        # css / markdown
        # prettier = {
        #   enable = true;
        #   package = pkgs.prettierd;
        #   settings.editorconfig = true;
        # };

        # english
        typos = {
          enable = false;
          # TODO: configure
        };
      };
    };
  };
}
