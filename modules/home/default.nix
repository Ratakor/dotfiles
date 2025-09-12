{
  config,
  lib,
  pkgs,
  self,
  specialArgs,
  ...
}:
let
  inherit (builtins) concatLists;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkAliasOptionModule mkForce;
  inherit (self.lib.filesystem) listFiles;
  inherit (self.lib.trivial) capitalize;

  username = "ratakor";

  extraModules = [
    (import "${self.pins.home-manager}/nixos")
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
    ];
    openssh.authorizedKeys.keys = self.keys.${username};
  };

  # I follow the .local convention: https://gist.github.com/Earnestly/84cf9670b7e11ae2eac6f753910efebe
  # Setting these variables to something different than their default causes
  # issue when a program that uses them start before they have been sourced.
  xdg = {
    config = ".local/etc";
    data = ".local/share";
    cache = ".local/var/cache";
    state = ".local/var/state"; # could be named log or lib too
  };

  # This is not a dotfiles manager it's a whole kitchen sink to manage
  # home configurations, hjem or basic stow implementation might be better
  # for raw dotfiles. Note that there is a stable version of home-manager.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = specialArgs;
    backupFileExtension = "hm.bak";

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
