# TODO: add oxidation?
{
  mkShellNoCC,
  zellij-wrapped,
  yazi-wrapped,
}:
mkShellNoCC {
  name = "wrapped-config";

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

    # zellij
  '';

  packages = [
    # neovim-wrapped # TODO: soon
    zellij-wrapped
    yazi-wrapped
  ];

  env = {
    EDITOR = "nvim";
  };
}
