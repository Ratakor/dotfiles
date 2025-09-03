{
  programs.bash = {
    # mfw `nix develop`
    interactiveShellInit = ''
      export HISTFILE=$XDG_STATE_HOME/bash_history
    '';
  };
}
