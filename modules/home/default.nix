{
  config,
  lib,
  pkgs,
  self,
  sources,
  ...
}:
let
  inherit (builtins) concatLists;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkAliasOptionModule mkForce;
  inherit (self.lib.filesystem) listFiles;
  inherit (self.lib.trivial) capitalize;
  inherit (config.self) username;

  extraModules = [
    (import "${sources.home-manager}/nixos")
  ];
  moduleAliases = [
    (mkAliasOptionModule [ "user" ] [ "users" "users" username ])
    (mkAliasOptionModule [ "hm" ] [ "home-manager" "users" username ])
  ];

  packages = singleton ./packages;
  programs = listFiles ./programs;
  services = listFiles ./services;
  scripts = singleton ./scripts;
  misc = listFiles ./misc;
in
{
  imports = concatLists [
    extraModules
    moduleAliases

    packages
    programs
    services
    scripts
    misc
  ];

  user = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    createHome = true;
    home = "/home/${username}";
    description = capitalize username;
    # TODO: change to initialHashedPassword
    initialPassword = "password"; # very secure
    extraGroups = [
      "wheel"
      # "audio"
      # "video"
      # "storage"
      # "network"
      "networkmanager"
      # "kvm"
      "docker"
      "libvirtd"
    ];
    openssh.authorizedKeys.keys = self.keys.${username};
  };

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
