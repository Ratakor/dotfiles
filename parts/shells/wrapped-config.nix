# TODO: add oxidation?
{
  mkShellNoCC,
  neovim-wrapped,
  zellij-wrapped,
  yazi-wrapped,
  ripgrep,
  fd,
}:
mkShellNoCC {
  name = "wrapped-config";

  packages = [
    neovim-wrapped
    zellij-wrapped
    yazi-wrapped
    ripgrep
    fd
  ];

  env = {
    EDITOR = "nvim";
  };

  # This work only for bash
  shellHook = ''
    alias e=nvim
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

    zellij attach --create main
  '';
}
