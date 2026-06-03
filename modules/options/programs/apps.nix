{ config, lib, ... }:
let
  inherit (builtins) mapAttrs;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nullOr package;

  mkEnableOption' = desc: mkEnableOption desc // { default = true; };

  mkEnablePackageOption = desc: default: {
    enable = mkEnableOption desc // {
      inherit default;
    };
    package = mkOption {
      type = nullOr package;
      default = null;
      internal = true;
    };
  };

  cfg = config.self.programs.apps;
in
{
  options.self.programs.apps = {
    enable = mkEnableOption "graphical apps";

    qbittorrent = mkEnablePackageOption "qBittorrent, BitTorrent client" true;
    discord = mkEnablePackageOption "Discord" true;
    spotify = mkEnablePackageOption "Spotify" true;
    anki = mkEnablePackageOption "Anki" false;

    keepassxc.enable = mkEnableOption' "KeePassXC, Password manager";
    gajim.enable = mkEnableOption' "Gajim, XMPP client";

    obs-studio.enable = mkEnableOption "OBS Studio";
    audacity.enable = mkEnableOption "Audacity, Sound Editor";
    libreoffice.enable = mkEnableOption "LibreOffice";
    onlyoffice.enable = mkEnableOption "ONLYOFFICE";
    blender.enable = mkEnableOption "Blender";
    teams.enable = mkEnableOption "Microsoft Teams";
    ledger-live.enable = mkEnableOption "Ledger Live";
    nixbit.enable = mkEnableOption "Nixbit, NixOS GUI Updater";
  };

  # This is better than changing `default` in helper function because
  # it will conflict with user definition if apps is not enabled.
  config.self.programs.apps = mkIf (!cfg.enable) (
    mapAttrs (_name: _value: { enable = false; }) (removeAttrs cfg [ "enable" ])
  );
}
