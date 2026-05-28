# A scrollable-tiling Wayland compositor
# This is peak use of nix for configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) concatStringsSep;
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.meta) getExe';

  prg = config.self.programs;
  dprg = prg.default;
  cfg = prg.windowManager.niri;

  input = import ./input.nix config;
  output = import ./output.nix { inherit config lib; };
  binds = import ./binds.nix config;
  switch-events = import ./switch-events.nix;
  layout = import ./layout.nix config;
  workspace = import ./workspace.nix;
  misc = import ./misc.nix config;
  window-rule = import ./window-rule.nix;
  layer-rule = import ./layer-rule.nix config;
  animations = import ./animations.nix;
  gestures = import ./gestures.nix;
  extraConfig =
    if cfg.extraConfig == "" then
      ""
    else
      "include \"${pkgs.writeText "niri-extra-config.kdl" cfg.extraConfig}\"";
in
{
  config = mkIf cfg.enable {
    self.programs.default.windowManager = mkIf (dprg.windowManager.name == "niri") {
      cmd = getExe' config.programs.niri.package "niri-session";
      session = "niri";
    };

    programs.niri = {
      enable = true;
      # package = pkgs.niri-git;
      useNautilus = false;
    };

    xdg.portal.config.niri = mkForce {
      default = [
        dprg.xdg.portal.name
        "gtk"
      ];

      "org.freedesktop.impl.portal.FileChooser" =
        if dprg.fileManager.name == "nautilus" then
          "gnome"
        else if dprg.fileManager.name == "dolphin" then
          "kde"
        else if prg.fileManager.yazi.portal.enable then
          "termfilechooser"
        else
          "gtk";

      "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
    };

    environment.systemPackages = with pkgs; [
      # https://github.com/YaLTeR/niri/wiki/Xwayland
      xwayland-satellite
    ];

    # This config is in the KDL format: https://kdl.dev
    # "/-" comments out the following node.
    # Check the wiki for a full description of the configuration:
    # https://github.com/YaLTeR/niri/wiki/Configuration:-Introduction
    hm.xdg.configFile."niri/config.kdl".text = concatStringsSep "\n" [
      input
      output
      binds
      switch-events
      layout
      workspace
      misc
      window-rule
      layer-rule
      animations
      gestures
      extraConfig
    ];
  };
}
