# Window Manager for Wayland
# kinda like dwm but without needing patches
# river mop when?
{
  config,
  lib,
  pkgs,
  ...
}@args:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.meta) getExe;

  RIVER_LOG_DIR = "${config.hm.xdg.stateHome}/river";
  prg = config.self.programs;
  dprg = prg.default;

  # I know this is a weird wrapper but we currently depend on
  # river-session.target created by home-manager
  # ??? we don't even use home-manager anymore
  wrapper = pkgs.writeShellScriptBin "river" ''
    timestamp=$(date +%Y-%m-%dT%H:%M:%S%z)
    mkdir -p "${RIVER_LOG_DIR}"
    exec dbus-run-session ${getExe config.programs.river-classic.package} -log-level warning > "${RIVER_LOG_DIR}/river-$timestamp.log" 2>&1
  '';
  wrapperExe = getExe wrapper;
in
{
  config = mkIf prg.windowManager.river-classic.enable {
    self.programs.default.windowManager = mkIf (dprg.windowManager.name == "river-classic") {
      cmd = wrapperExe;
      session = "river"; # ?
    };

    programs.river-classic = {
      enable = true;
      xwayland.enable = true;
      extraPackages = mkForce [ ];
    };

    hm.xdg.configFile."river/init".text = import ./init.nix args;

    systemd.user.services.river = {
      enable = true;
      description = "River Wayland Compositor";
      bindsTo = [ "graphical-session.target" ];
      before = [ "graphical-session.target" ]; # ?
      wants = [
        "graphical-session-pre.target"
        # "xdg-desktop-autostart.target"
      ];
      after = [
        "graphical-session-pre.target"
        # "xdg-desktop-autostart.target"
      ];

      # ?
      serviceConfig = {
        Slice = "session.slice";
        Type = "notify";
        ExecStart = wrapperExe;
      };
    };
  };
}
