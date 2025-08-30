{
  lib,
  config,
  ...
}: {
  imports = [
    ./programs
    ./misc
    ./services # TODO: move stuff from programs there
  ];

  home = {
    username = "ratakor";
    homeDirectory = "/home/ratakor";
    stateVersion = "25.05";

    # see ./misc/impurity.nix
    dotfiles = "${config.home.homeDirectory}/nixos/users/ratakor";
  };

  # Allow HM to manage itself when in standalone mode.
  # This makes the home-manager command available to users.
  programs.home-manager.enable = true;
}
