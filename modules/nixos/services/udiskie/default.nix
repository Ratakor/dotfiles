# USB device manager (auto-mounting)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe';

  dprg = config.self.programs.default;
  cfg = config.self.services.udiskie;
  package = pkgs.udiskie;
in
{
  config = mkIf cfg.enable {
    services.udisks2.enable = true;

    user.packages = [ package ];

    hj.systemd.units.udiskie = {
      description = "udiskie mount daemon";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = getExe' package "udiskie";
        # Restart = "always";
      };
    };

    hj.xdg.config.files."udiskie/config.yml".text = /* yaml */ ''
      program_options:
        automount: true
        notify: true
        tray: false
        terminal: ${dprg.terminal.cmdDir}
    '';
  };
}
