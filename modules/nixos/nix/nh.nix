{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) concatStringsSep;
  inherit (lib.strings) escapeShellArg;
  inherit (lib.lists) length zipListsWith;
in
{
  # nix helper
  programs.nh = {
    enable = true;

    clean = {
      enable = false; # idk if I want automatic cleaning actually
      extraArgs = "--keep 5 --keep-size 7d";
      dates = "weekly";
    };

    # Set NH_FLAKE env variable for the default flake path.
    flake = "${config.user.home}/nixos";

    package = pkgs.nh.override {
      nix-output-monitor =
        let
          oldIcons = [
            "↑"
            "↓"
            "⏱"
            "⏵"
            "✔"
            "⏸"
            "⚠"
            "∅"
            "∑"
          ];
          newIcons = [
            "f062" # 
            "f063" # 
            "f520" # 
            "f04b" # 
            "f00c" # 
            "f04c" # 
            "f071" # 
            "f1da" # 
            "f04a0" # 󰒠
          ];
        in
        assert length oldIcons == length newIcons;
        pkgs.nix-output-monitor.overrideAttrs (prevAttrs: {
          postPatch = (prevAttrs.postPatch or "") + ''
            sed -i ${
              escapeShellArg (concatStringsSep "\n" (zipListsWith (a: b: "s/${a}/\\\\x${b}/") oldIcons newIcons))
            } lib/NOM/Print.hs

            substituteInPlace lib/NOM/Print/Tree.hs --replace-fail '┌' '╭'
          '';
        });
    };
  };
}
