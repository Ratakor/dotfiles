{
  config,
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (builtins) concatLists concatMap;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkAliasOptionModule mkForce;
  inherit (lib.filesystem) listFiles listFilesRecursive;

  username = config.self.user.name;

  extraModules = [
    (import "${sources.home-manager}/nixos")
  ];
  moduleAliases = [
    (mkAliasOptionModule [ "user" ] [ "users" "users" username ])
    (mkAliasOptionModule [ "hm" ] [ "home-manager" "users" username ])
  ];

  programs = listFiles ./programs;
  services = listFiles ./services;
  scripts = singleton ./scripts;
  misc = listFilesRecursive ./misc;
in
{
  imports = concatLists [
    extraModules
    moduleAliases

    programs
    services
    scripts
    misc
  ];

  user = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.${config.self.programs.default.shell.name};
    createHome = true;
    home = "/home/${username}";
    description = config.self.user.fullName;
    # TODO: change to initialHashedPassword
    initialPassword = "password"; # very secure
    # Should these be set in there corresponding config?
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "podman"
      "libvirtd"
      "kvm"
    ];
    openssh.authorizedKeys.keys = config.self.user.keys;
    packages =
      listFiles ./packages |> concatMap (path: import path { inherit config lib pkgs; }) |> concatLists;
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
