{
  config,
  pkgs,
  ...
}: {
  home.shell.enableZshIntegration = true;

  home.packages = with pkgs; [
    zsh-completions
    nix-zsh-completions
  ];

  programs.zsh = {
    enable = true;
    # TODO
    dotDir = "${config.xdg.configHome}/zsh-nix";
    # extra...
    # sessionVariables = {};
    # setOptions = [];
    # shellAliases = {};
    # shellGlobalAliases = {};
  };

  home.file."${config.xdg.configHome}/zsh" = {
    source = ./zsh;
    recursive = true;
  };
}
