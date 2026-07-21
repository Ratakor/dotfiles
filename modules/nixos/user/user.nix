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

  # it is impossible for any string to hash to "!"
  # this locks the root account
  users.users.root.hashedPassword = "!";

  user = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    createHome = true;
    home = "/home/${username}";
    description = config.self.user.fullName;
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
