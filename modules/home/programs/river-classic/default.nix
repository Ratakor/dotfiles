# Window Manager for Wayland
# kinda like dwm but without needing patches
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) readFile;
  inherit (lib.meta) getExe;
  inherit (config.self) colors;
in {
  hm.wayland.windowManager.river = {
    enable = config.self.displayServer == "wayland";

    # TODO: maybe wrap all programs with their configs, currently this doesn't
    # work because XDG_CONFIG_HOME is not set but if all programs are wrapped
    # there should be no issue, tbh I kinda like this idea, it's really nix way
    # but that would require to get rid of home-manager, also it's kinda a
    # .local convention replacement so we can go back to use .config for
    # programs that sucks

    # package = let
    #   RIVER_LOG_DIR = "${config.xdg.stateHome}/river";
    #   RIVER_CONFIG = "${config.xdg.configHome}/river/init";
    #   river = getExe pkgs.river;
    # in pkgs.writeShellScriptBin "river" ''
    #   timestamp=$(date +%Y-%m-%dT%H:%M:%S%z)
    #   mkdir -p "${RIVER_LOG_DIR}"
    #   exec dbus-run-session ${river} -c ${RIVER_CONFIG} -log-level warning > "${RIVER_LOG_DIR}/river-$timestamp.log" 2>&1
    # '';

    # This is unrelated to the above see
    # https://codeberg.org/river/river-classic
    # https://codeberg.org/river/river
    # I want river 0.4.0 btw
    package = pkgs.river-classic;

    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
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
      hide-cursor = ["when-typing enabled"];
      set-cursor-warp = "on-output-change";
      set-repeat = "50 300";
      keyboard-layout = "-variant us -options caps:none fr";
      default-layout = "rivertile";

      background-color = "0x${colors.background}";
      border-color-focused = "0x${colors.blue}";
      border-color-unfocused = "0x${colors.unfocused}";
      border-color-urgent = "0x${colors.red}";
    };

    extraConfig = readFile ./river-init.sh;
  };
}
