{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = false;
    vimAlias = false;
    vimdiffAlias = true;

    # withNodeJs = true;
    # withPython3 = true;
    # withRuby = true;
  };

  home.file."${config.xdg.configHome}/nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
