{
  # TODO: use this, see git config too -> personal.nix loaded if username == "ratakor"
  # TODO: use nix/git secrets, also needed for github copilot
  # username,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./programs
    ./shell
    ./dotfiles
  ];

  home = {
    # inherit username;
    # homeDirectory = "/home/${username}";
    username = "ratakor";
    homeDirectory = "/home/ratakor";
    stateVersion = "25.05";
  };

  # programs.home-manager.enable = true;
}
