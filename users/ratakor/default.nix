{
  lib,
  config,
  ...
}: {
  imports = [
    ./modules
    ./config
    # ./programs
    # ./misc
    # ./scripts
    # ./services # TODO: move all services in ./programs there
  ];

  # home = {
  #   username = "ratakor";
  #   homeDirectory = "/home/ratakor";
  #   stateVersion = "25.05";

  #   # see ./misc/impurity.nix
  #   dotfiles = "${config.home.homeDirectory}/nixos/users/ratakor";
  # };
}
