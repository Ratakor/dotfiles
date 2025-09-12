# Terminal File Manager
{ self, ... }:
{
  user.packages = [ self.pkgs.yazi-wrapped ];

  # Add a shell wrapper (`y`) that changes cwd when exiting yazi
  hm.programs.zsh.initContent = ''
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
