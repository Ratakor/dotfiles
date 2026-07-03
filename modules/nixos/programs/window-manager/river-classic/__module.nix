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

  wrapper = pkgs.writeShellScriptBin "river" ''
    timestamp=$(date +%Y-%m-%dT%H:%M:%S%z)
    mkdir -p "${RIVER_LOG_DIR}"

    # used to be prefixed with `exec dbus-run-session `
    ${getExe pkgs.river-classic} -log-level warning > "${RIVER_LOG_DIR}/river-$timestamp.log" 2>&1
    exit_code=$?

    systemctl --user stop river-session.target
    systemctl --user stop graphical-session.target

    exit $exit_code
  '';

  wrapperExe = getExe wrapper;
in
{
  config = mkIf prg.windowManager.river-classic.enable {
    self.programs.default.windowManager = mkIf (dprg.windowManager.name == "river-classic") {
      cmd = wrapperExe;
      # "river" doesn't work with systemd, use a greetd login manager like tuigreet instead
      session = "river";
    };

    programs.river-classic = {
      enable = true;
      xwayland.enable = true;
      extraPackages = mkForce [ ];
    };

    hm.xdg.configFile."river/init" = {
      text = import ./init.nix args;
      executable = true;
    };

    systemd.user.targets.river-session = {
      enable = true;
      description = "River compositor session";
      bindsTo = [ "graphical-session.target" ];
      wants = [
        "graphical-session-pre.target"
        "graphical-session.target"
      ];
      after = [ "graphical-session-pre.target" ];
    };

    /*
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
    */
  };
}
