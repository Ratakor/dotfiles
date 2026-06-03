{ keys, ... }:
{
  users = {
    mutableUsers = false;

    users = {
      root = {
        initialPassword = "";
        openssh.authorizedKeys.keys = keys.ratakor;
      };

      nixos = {
        isNormalUser = true;
        uid = 1000;
        initialPassword = "";
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
        ];
        openssh.authorizedKeys.keys = keys.ratakor;
      };
    };
  };
}
