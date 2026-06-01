{ lib, ... }:
let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nullOr package;

  # default = true only if video is enabled?
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
in
{
  options.self.programs.apps = {
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
}
