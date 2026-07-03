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

  unwrappedRiver = pkgs.river-classic;

  wrapper = pkgs.writeShellScriptBin "river" ''
    timestamp=$(date +%Y-%m-%dT%H:%M:%S%z)
    mkdir -p "${RIVER_LOG_DIR}"

    # Import login environment variables into systemd user manager
    systemctl --user import-environment PATH DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_CLASS XDG_SESSION_DESKTOP XDG_SEAT XDG_VTNR
    ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd PATH DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_CLASS XDG_SESSION_DESKTOP XDG_SEAT XDG_VTNR

    # Start the systemd service for river and wait for it to exit
    echo "Starting river-classic via systemd..." > "${RIVER_LOG_DIR}/river-$timestamp.log"
    systemctl --user start --wait river.service >> "${RIVER_LOG_DIR}/river-$timestamp.log" 2>&1
  '';

  wrapperExe = getExe wrapper;

  riverWrapped =
    (pkgs.symlinkJoin {
      name = "river-wrapped-${lib.getVersion unwrappedRiver}";
      paths = [ unwrappedRiver ];
      postBuild = ''
        # Remove the original /bin/river symlink to prevent conflicts
        rm $out/bin/river
        # Copy our wrapper script to $out/bin/river
        cp ${wrapper}/bin/river $out/bin/river
      '';
    })
    // {
      override = unwrappedRiver.override;
      overrideAttrs = unwrappedRiver.overrideAttrs;
    };
in
{
  config = mkIf prg.windowManager.river-classic.enable {
    self.programs.default.windowManager = mkIf (dprg.windowManager.name == "river-classic") {
      cmd = wrapperExe;
      session = "river";
    };

    programs.river-classic = {
      enable = true;
      package = riverWrapped;
      xwayland.enable = true;
      extraPackages = mkForce [ ];
    };

    hm.xdg.configFile."river/init".text = import ./init.nix args;

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

    systemd.user.services.river = {
      enable = true;
      description = "River Wayland Compositor";
      bindsTo = [ "graphical-session.target" ];
      before = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];

      serviceConfig = {
        Slice = "session.slice";
        Type = "simple";
        ExecStart = "${unwrappedRiver}/bin/river -log-level warning";
        ExecStopPost = "${pkgs.systemd}/bin/systemctl --user stop river-session.target graphical-session.target";
      };
    };
  };
}
