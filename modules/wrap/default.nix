# Adapted from github:viperML/wrapper-manager/modules/many-wrappers.nix
# This should probably be moved to its own repo
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) mapAttrs attrValues;
  inherit (lib) types;
  inherit (lib.options) mkOption;
  inherit (lib.attrsets) filterAttrs;
  inherit (lib.filesystem) listFilesRecursive;

  cfg = config.wrap;
in {
  imports = listFilesRecursive ./modules;

  options.wrap = {
    build = {
      toplevel = mkOption {
        type = types.package;
        readOnly = true;
        description = ''
          (Read-only) Pacakge that merges all the enabled wrappers into a single derivation.
          You may want to use build.packages instead.
        '';
      };
      packages = mkOption {
        type = with types; attrsOf package;
        readOnly = true;
        description = ''
          (Read-only) Attribute set of name=pkg, for each enabled wrapper.
        '';
      };
    };
  };

  config = {
    wrap.build = {
      toplevel = pkgs.buildEnv {
        name = "wrap-bundle";
        paths = attrValues cfg.build.packages;
      };

      packages =
        cfg.programs
        |> filterAttrs (_: v: v.enable)
        |> mapAttrs (_: v: v.wrapped);
    };

    # This shouldn't be here
    # TODO: expose `cfg.build.packages` to the flake (in its own namespace)
    users.users.ratakor.packages = [
      cfg.build.toplevel
    ];
  };
}
