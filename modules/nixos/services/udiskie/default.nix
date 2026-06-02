# USB device manager (auto-mounting)
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  dprg = config.self.programs.default;
  cfg = config.self.services.udiskie;
in
{
  config = mkIf cfg.enable {
    services.udisks2.enable = true;
    user.packages = [ pkgs.udiskie ];

    systemd.user.services.udiskie = {
      description = "udiskie auto-mount daemon";
      bindsTo = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.udiskie}/bin/udiskie --automount --notify --tray never";
        Restart = "always";
      };
    };

    hj.xdg.config.files."udiskie/config.yml".text = ''
      program_options:
        terminal: ${dprg.terminal.cmdDir}
    '';

    /*
    hm.services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "never";
      settings = {
        program_options = {
          terminal = dprg.terminal.cmdDir;
        };
      };
    };
    */
  };
}
