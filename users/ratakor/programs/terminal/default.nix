{
  imports = [
    ./dev.nix # Development tools
    ./misc.nix # Miscellaneous tools
    ./oxidation.nix # Replacement of various shell utilities

    ./gpg.nix # GNU Privacy Guard
    ./git # VCS Client + TUI
    ./quand.nix # Calendar CLI
    ./neovim # Editor
    ./newsboat # RSS Reader
    ./senpai.nix # IRC Client
    ./ssh.nix # SSH Client
    ./yazi # File Manager
    # ./zellij # Terminal Multiplexer
    ./zsh # Shell

    ./fzf # TODO: remove
  ];
}
