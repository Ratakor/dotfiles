{
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  # TODO: this is ugly
  nvimPath = "${config.home.homeDirectory}/nixos/home/ratakor/programs/terminal/editor/nvim";
in {
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = false;
    vimAlias = false;
    vimdiffAlias = true;

    # withNodeJs = true;
    # withPython3 = true;
    # withRuby = true;

    extraPackages = with pkgs; [
      tree-sitter
    ];
  };

  xdg.configFile.nvim.source = mkOutOfStoreSymlink nvimPath;
}
