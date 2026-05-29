{
  programs.bash = {
    # mfw `nix develop`
    interactiveShellInit = /* bash */ ''
      # XDG_STATE_HOME is not defined for all users and we don't use bash anyway
      # export HISTFILE=$XDG_STATE_HOME/bash_history
      export HISTFILE=/dev/null
    '';
  };
}
