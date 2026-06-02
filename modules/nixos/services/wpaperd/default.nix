# Wallpaper Daemon
# See `wpaperctl` to control the daemon.
# btw super cool stuff, wpaperd creates symlinks in $XDG_STATE_HOME/wpaperd/wallpapers
# that points to the current wallpaper used.
#
# I wish I could enable this and replace randwp but it's crashing on X200
# The application panicked (crashed).
# Message:  Failed to create vertices shader:
#    0: 0:2(10): error: GLSL ES 3.10 is not supported. Supported versions are: 1.00 ES
# TODO: replace randwp in
# - yazi wrapper
# - plumber
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.self.services.wpaperd;
in
{
  config = mkIf cfg.enable {
    user.packages = [ pkgs.wpaperd ];

    hj.xdg.config.files."wpaperd/wallpaper.toml".text = /* toml */ ''
      [default]
      path = "${config.self.wallpapers}"
      duration = "15m"
      sorting = "random"
      mode = "center"
      transition-time = 400 # default: 300
      queue-size = 5 # default: 10
      initial-transition = true # default: true
      recursive = true # default: true

      # colour-distance goes hard too
      [default.transition.glitch-memories]
    '';

    # FIXME
    hj.systemd.units.wpaperd = {
      description = "Wallpaper daemon";
      # TODO ConditionEnvironment = "WAYLAND_DISPLAY"
      bindsTo = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.wpaperd}/bin/wpaperd";
        Restart = "always";
      };
    };
  };
}
