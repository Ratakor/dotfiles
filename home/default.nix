{
  config,
  inputs,
  lib,
  specialArgs,
  ...
}: let
  inherit (lib.modules) mkForce;
  inherit (lib.attrsets) genAttrs;

  usernames = ["ratakor"];
in {
  home-manager = {
    verbose = true;
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = inputs // specialArgs; # is this correct?
    backupFileExtension = "hm.bak";
    users = genAttrs usernames (name: ./${name});

    # Shared configuration applied to all users
    sharedModules = [
      {
        # Ensure that HM uses the same Nix package as NixOS.
        nix.package = mkForce config.nix.package;

        # Allow HM to manage itself when in standalone mode.
        # This makes the home-manager command available to users.
        programs.home-manager.enable = true;
      }
    ];
  };
}
