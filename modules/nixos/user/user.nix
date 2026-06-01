{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkAliasOptionModule;

  username = config.self.user.name;
in
{
  imports = [
    (mkAliasOptionModule [ "user" ] [ "users" "users" username ])
  ];

  users.users.root.initialPassword = "password";

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
  };
}
