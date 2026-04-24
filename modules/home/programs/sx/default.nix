# Simple alternative to both xinit and startx for starting a Xorg server
# TODO: see services.xserver.displayManager.sx
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  sys = config.self.system;
in
{
  config = mkIf sys.displayServer.x11 {
    user.packages = [ pkgs.sx ];
    hm.xdg.configFile = {
      "sx/sxrc" = {
        source = ./sxrc;
        executable = true;
      };
      "sx/gruvbox-dark".source = ./gruvbox-dark;
    };

    # TODO: clean that up
    hm.programs.zsh.profileExtra = ''
      if [ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1; then
         exec sx
      fi
    '';
  };
}
