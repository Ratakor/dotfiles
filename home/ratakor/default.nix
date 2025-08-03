{
  wallpapers,
  username,
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
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  # TODO: this shouldn't be here
  home.file."${config.xdg.userDirs.pictures}/wallpapers".source = wallpapers;

  # TODO: what is that?
  # programs.home-manager.enable = true;
}
