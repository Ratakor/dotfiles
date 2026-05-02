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
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe';

  prg = config.self.programs;

  input = import ./input.nix;
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
in
{
  config = mkIf prg.windowManager.niri.enable {
    self.programs.default.windowManager = mkIf (prg.default.windowManager.name == "niri") {
      cmd = getExe' config.programs.niri.package "niri-session";
    };

    # btw this is NixOS's programs not home-manager's programs.
    # guess why we're using this one
    programs.niri = {
      enable = true;
      # package = pkgs.niri-git;
    };

    environment.systemPackages = with pkgs; [
      # File manager for the File chooser portal.
      # https://github.com/YaLTeR/niri/wiki/Important-Software#portals
      nautilus
      # https://github.com/YaLTeR/niri/wiki/Xwayland
      xwayland-satellite
    ];

    # Disabled by default, but re-enabled by some packages:
    # niri: https://github.com/YaLTeR/niri/wiki/Important-Software#portals
    # services.gnome = {
    #   gnome-keyring.enable = mkForce false;
    #   # gcr-ssh-agent.enable = false; # config.services.gnome.gnome-keyring.enable
    # };

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
    ];
  };
}
