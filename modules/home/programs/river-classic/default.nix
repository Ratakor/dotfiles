# Window Manager for Wayland
# kinda like dwm but without needing patches
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) readFile;
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe;

  colors = config.self.colors.default;
  XDG_DOCUMENTS_DIR = config.hm.xdg.userDirs.documents;
  RIVER_LOG_DIR = "${config.hm.xdg.stateHome}/river";
  prg = config.self.programs;
  dprg = prg.default;
in
{
  config = mkIf (prg.windowManager == "river") {
    programs.river-classic.enable = true; # river mop when?

    hm.wayland.windowManager.river = {
      enable = true;

      # I know this is a weird wrapper but we currently depend on
      # river-session.target created by home-manager
      package = pkgs.writeShellScriptBin "river" ''
        timestamp=$(date +%Y-%m-%dT%H:%M:%S%z)
        mkdir -p "${RIVER_LOG_DIR}"
        exec dbus-run-session ${getExe pkgs.river-classic} -log-level warning > "${RIVER_LOG_DIR}/river-$timestamp.log" 2>&1
      '';

      xwayland.enable = true;
      systemd = {
        enable = true;
        # variables = [ "--all" ];
      };

      extraSessionVariables = {
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "river";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1"; # enable ozone wayland for chromium and electron based apps
      };

      settings = {
        focus-follows-cursor = "normal";
        attach-mode = "bottom";
        hide-cursor = [ "when-typing enabled" ];
        set-cursor-warp = "on-output-change";
        set-repeat = "50 300";
        keyboard-layout = "-variant us -options caps:none fr";
        default-layout = "rivertile";

        background-color = "0x${colors.background}";
        border-color-focused = "0x${colors.blue}";
        border-color-unfocused = "0x${colors.unfocused}";
        border-color-urgent = "0x${colors.red}";

        map.normal = {
          "Super Return" = "spawn '${dprg.terminal.cmd}'";
          "Super D" = "spawn '${dprg.launcher.drun}'";
          "Super+Shift D" = "spawn '${dprg.launcher.run}'";
          "None XF86ScreenSaver" = "spawn '${dprg.locker.cmd}'";
          "Super+Shift X" = "spawn '${dprg.locker.cmd}'";
          "None XF86Battery" = "spawn 'battery'";
          "Super+Shift W" = "spawn 'randwp'";
          "None Print" = "spawn 'screenshot'";
          # "None F7" = "spawn '${config.self.terminal.cmd} -e dmenurecord'";
          # "Super B" = "spawn '$BROWSER'";
          # "Super N" = "spawn '${config.self.terminal.cmd} -e yazi ${XDG_DOCUMENTS_DIR}/notes'";
          "Super N" =
            "spawn '${dprg.terminal.cmdDir} ${XDG_DOCUMENTS_DIR}/notes -e zellij attach --create notes'";
          "Super+Shift N" = "spawn '${dprg.terminal.cmd} -e newsboat'";
        };
      };

      extraConfig = readFile ./river-init.sh;
    };

    systemd.user.services.river = {
      enable = false;
      description = "River Wayland Compositor";
      bindsTo = [ "graphical-session.target" ];
      before = [ "graphical-session.target" ];
      wants = [
        "graphical-session-pre.target"
        "xdg-desktop-autostart.target"
      ];
      after = [
        "graphical-session-pre.target"
        "xdg-desktop-autostart.target"
      ];

      serviceConfig = {
        Slice = "session.slice";
        Type = "notify";
        ExecStart = "${getExe config.hm.wayland.windowManager.river.package}";
      };
    };
  };
}
