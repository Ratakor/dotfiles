{ pkgs, lib, ... }:
let
  inherit (builtins) mapAttrs;
  inherit (lib.modules) mkDefault mkForce;
in
{
  system.nixos.tags = [ "headless" ];

  documentation = mapAttrs (_name: mkForce) {
    enable = false;
    dev.enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  environment = {
    defaultPackages = mkForce [ ];
    stub-ld.enable = false;
    variables.BROWSER = mkDefault "echo";
  };

  fonts.fontconfig.enable = false;

  # Install less voices for speechd to save some space
  nixpkgs.overlays = [
    (_final: prev: {
      mbrola-voices = prev.mbrola-voices.override {
        # only ship with one voice per language
        languages = [ "*1" ];
      };
    })
  ];

  programs = {
    nano.enable = false; # use helix instead :P
    command-not-found.enable = mkForce false;
  };

  services = {
    # logrotate.enable = mkDefault false; # useful for servers
    udisks2.enable = false;
    xserver.excludePackages = [ pkgs.xterm ];
  };

  systemd = {
    enableEmergencyMode = false;
    sleep.settings.Sleep = {
      AllowSuspend = "no";
      AllowHibernation = "no";
    };
  };

  xdg = mapAttrs (_: mkForce) {
    autostart.enable = false;
    icons.enable = false;
    menus.enable = false;
    mime.enable = false;
    portal.enable = false;
    sounds.enable = false;
  };
}
