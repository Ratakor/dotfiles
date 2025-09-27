# nix develop github:ratakor/dotfiles --accept-flake-config --quiet --quiet
# alias hx="nix run github:ratakor/dotfiles#helix-wrapped --accept-flake-config --quiet --quiet --"
# TODO: add oxidation? (also add nerd fonts?)
{
  mkShellNoCC,
  neovim-wrapped,
  zellij-wrapped,
  yazi-wrapped,
  helix-wrapped,
  ripgrep,
  fd,
}:
mkShellNoCC {
  name = "wrapped-config";

  packages = [
    neovim-wrapped
    zellij-wrapped
    yazi-wrapped
    helix-wrapped
    ripgrep
    fd
  ];

  env = {
    # EDITOR = "nvim";
    EDITOR = "hx";
  };

  # This work only for bash
  shellHook = ''
    alias e='$EDITOR'
    alias z='zellij --layout welcome'
    alias zac='zellij attach --create'

    function y() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
      yazi "$@" --cwd-file="$tmp"
      if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
      fi
      rm -f -- "$tmp"
    }
  '';
}
