{
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib.modules) mkAliasOptionModule;
in {
  imports = [
    (mkAliasOptionModule ["user"] ["users" "users" "ratakor"])
  ];

  user = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    createHome = true;
    home = "/home/ratakor";
    description = "Ratakor";
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
    openssh.authorizedKeys.keys = self.keys.ratakor;
  };
}
