{
  imports = [
    ./bash.nix
    ./git.nix
    ./zsh.nix
  ];

  programs = {
    # Pager
    less.enable = true;
  };
}
