# TODO:
# Config all that.
# I don't know if I like it tho, maybe it's better to setup `nix flake check`
# instead and run a CI with it.
# Also remember to uncomment shellHook in ./shell.nix & enable this in ./default.nix.
{inputs, ...}: {
  imports = [inputs.git-hooks.flakeModule];
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (lib.attrsets) recursiveUpdate;

    # Files to be ignored by all hooks. Must be a list of python regexes.
    excludes = ["LICENSE" "flake.lock" "\.svg$" "\.age$" "\.sh$"];

    # Helper function to generate TOML configuration for pre-commit hooks
    # that read TOML configurations.
    toTOML = name: (pkgs.formats.toml {}).generate "${name}";

    # Recursively updates a hook configuration set with the preset
    # configuration options.
    presetConfigFor = name: {
      inherit excludes;
      description = "pre-commit hook for ${name}";
      fail_fast = true; # stop running hooks if this hook fails
      verbose = true;
    };

    # Note: hookConfig should be *after* presetConfig to allow overriding
    # preset defaults. If this list is flipped, values present in presetConfig
    # will override hookConfig.
    mkHook = name: hookConfig: recursiveUpdate (presetConfigFor name) hookConfig;
  in {
    # https://flake.parts/options/git-hooks-nix.html
    pre-commit = {
      check.enable = true; # Perform pre-commit checks in `nix flake check`.

      settings = {
        inherit excludes;

        hooks = {
          treefmt = mkHook "treefmt" {
            enable = false;
            # settings.edit = true;
          };

          statix = mkHook "statix" {
            enable = false;
            # excludes = [".direnv" "npins"];
          };

          deadnix = mkHook "deadnix" {
            enable = false;
            settings = {
              noLambdaPatternNames = true;
            };
          };

          # inlcudes = ["*.sh" "*.bash"];
          # shellcheck = mkHook "shellcheck" {
          #   enable = true;
          #   # settings.version = "0.9.0";
          #   excludes = [".direnv" "npins"];
          # };

          # locale = "en-us"
          # typos = mkHook "typos" {
          #   enable = true;
          #   settings = toTOML "typos" {
          #     skip = ["teh" "adn"];
          #     skip_file = ["CHANGELOG.md"];
          #   };
          # };
        };
      };
    };
  };
}
