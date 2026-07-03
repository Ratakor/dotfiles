# TODO: finish this, anyrun kinda sucks so I kinda cba
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  # inherit (config.self) colors;

  prg = config.self.programs;
in
{
  # config = mkIf prg.launcher.anyrun.enable {
  config = mkIf false {
    # self.programs.default.launcher = mkIf (prg.default.launcher.name == "anyrun") {
    #   dmenu = "anyrun"; # ??
    #   drun = "anyrun";
    #   run = "anyrun"; # no equivalent?
    # };

    hm.programs.anyrun = {
      enable = true;
      config = {
        x.fraction = 0.5;
        y.fraction = 0.3;
        width.fraction = 0.3;
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = false;
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = 10;

        plugins = [
          "${pkgs.anyrun}/lib/libapplications.so"
          "${pkgs.anyrun}/lib/libsymbols.so"
          "${pkgs.anyrun}/lib/librink.so"
          "${pkgs.anyrun}/lib/libshell.so"
          "${pkgs.anyrun}/lib/libtranslate.so"
          "${pkgs.anyrun}/lib/libkidex.so"
          "${pkgs.anyrun}/lib/librandr.so"
          "${pkgs.anyrun}/lib/libstdin.so"
          "${pkgs.anyrun}/lib/libdictionary.so"
          "${pkgs.anyrun}/lib/libwebsearch.so"
          "${pkgs.anyrun}/lib/libnix_run.so"
          "${pkgs.anyrun}/lib/libniri_focus.so"
          "${pkgs.anyrun}/lib/libactions.so"
          # anyrun nixos options ...
        ];
      };

      # extraCss = /* css */ ''
      #   .some_class {
      #     background: red;
      #   }
      # '';

      # extraConfigFiles = {
      #   "some-plugin.ron".text = /* ron */ ''
      #     Config(
      #       // for any other plugin
      #       // this file will be put in ~/.config/anyrun/some-plugin.ron
      #       // refer to docs of xdg.configFile for available options
      #     )
      #   '';
      # };
    };
  };
}
