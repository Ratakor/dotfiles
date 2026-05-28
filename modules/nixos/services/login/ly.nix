{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe;

  sys = config.self.system;
  cfg = sys.login;

  brightnessctl = getExe pkgs.brightnessctl;
in
{
  services.displayManager.ly = mkIf (cfg.manager == "ly") {
    enable = true;
    x11Support = false;
    settings = {
      clear_password = true;
      vi_mode = true;
      vi_default_mode = "insert";
      session_log = ".local/state/ly-session.log"; # xdg
      brightness_down_cmd = "${brightnessctl} -q set 10%-";
      brightness_up_cmd = "${brightnessctl} -q set +10%";
      animation = "colormix"; # none, doom, matrix, colormix, gameoflife
      bigclock = "en";
      bigclock_seconds = true; # doesn't work
      clock = "%c";
    };
  };
}
