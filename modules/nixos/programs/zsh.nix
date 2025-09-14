{
  programs.zsh = {
    enable = true;

    shellInit = ''
      export ZDOTDIR=$HOME/.config/zsh
    '';

    # I think that this controls wether zsh completion output are installed to
    # the system so it must be set to true even if configuring zsh through
    # home-manager. Set `no_global_rcs` to prevent duplicate compinit calls.
    # https://github.com/nix-community/home-manager/issues/3965
    enableCompletion = true;
  };
}
