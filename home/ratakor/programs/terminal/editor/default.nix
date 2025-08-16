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

    extraPackages = with pkgs; [
      tree-sitter
    ];
  };

  # TODO: manage nix config with nixvim or nvf or whatever instead of doing
  # impure out of store symlinks even though I like mutable configs
  xdg.configFile.nvim.source = "${config.home.dotfiles}/programs/terminal/editor/nvim";
}
