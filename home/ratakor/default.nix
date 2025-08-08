{
  username,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./programs
    ./misc
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  # Allow HM to manage itself when in standalone mode.
  # This makes the home-manager command available to users.
  programs.home-manager.enable = true;
}
