{
  config,
  lib,
  sources,
  ...
}:
let
  inherit (lib.modules) mkAliasOptionModule mkForce;

  username = config.self.user.name;
in
{
  imports = [
    sources.home-manager.nixosModules.default
    (mkAliasOptionModule [ "hm" ] [ "home-manager" "users" username ])
  ];

  # This is not a dotfiles manager it's a whole kitchen sink to manage
  # home configurations, hjem or basic stow implementation might be better
  # for raw dotfiles.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # See also `backupCommand`
    backupFileExtension = "hm.bak";
    overwriteBackup = true;

    users.${username}.home = {
      inherit username;
      homeDirectory = config.user.home;
      stateVersion = "25.05";
    };

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
