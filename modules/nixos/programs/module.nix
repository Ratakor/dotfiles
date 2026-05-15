{ lib, pkgs, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  programs = {
    bash = {
      # mfw `nix develop`
      interactiveShellInit = /* bash */ ''
        # XDG_STATE_HOME is not defined for all users and we don't use bash anyway
        # export HISTFILE=$XDG_STATE_HOME/bash_history
        export HISTFILE=/dev/null
      '';
    };

    zsh = {
      enable = true; # I known about config.self.programs.shell.zsh.enable and idc
      shellInit = /* zsh */ ''
        export ZDOTDIR=$HOME/.config/zsh
      '';
      # I think that this controls whether zsh completion output are installed to
      # the system so it must be set to true even if configuring zsh through
      # home-manager. Set `no_global_rcs` to prevent duplicate compinit calls.
      # https://github.com/nix-community/home-manager/issues/3965
      enableCompletion = true;
    };

    git = {
      enable = true;
      package = pkgs.gitMinimal;
    };

    nano.enable = mkForce false;
  };
}
