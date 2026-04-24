# nix develop github:ratakor/dotfiles#wrapped-config --extra-experimental-features pipe-operators --quiet --quiet
# alias hx="nix run github:ratakor/dotfiles#helix-wrapped --extra-experimental-features pipe-operators --quiet --quiet --"
# TODO: add oxidation? (also add nerd fonts?)
# it's funny how this look like yazelix
{
  mkShellNoCC,
  # neovim-wrapped,
  zellij-wrapped,
  yazi-wrapped,
  helix-wrapped,
  gitui-wrapped,
  ripgrep,
  fd,
}:
mkShellNoCC {
  name = "wrapped-config";

  packages = [
    # neovim-wrapped
    zellij-wrapped
    yazi-wrapped
    helix-wrapped
    gitui-wrapped
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
