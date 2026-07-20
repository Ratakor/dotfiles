{
  config,
  lib,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf;

  # colors = config.self.colors.default;
  prg = config.self.programs;
  dprg = prg.default;
  isDefaultBar = dprg.statusBar.name == "noctalia";
in
{
  config = mkIf prg.desktopShell.noctalia.enable {
    self.programs.default = {
      statusBar = mkIf isDefaultBar {
        toggle = "noctalia msg bar-toggle";
      };
      locker = mkIf (dprg.locker.name == "noctalia") {
        cmd = "noctalia msg session lock";
      };
      powerMenu = mkIf (dprg.powerMenu.name == "noctalia") {
        cmd = "noctalia msg panel-toggle session";
      };
    };

    hm.imports = [ sources.noctalia.homeModules.default ];

    hm.programs.noctalia = {
      enable = true;
      systemd.enable = isDefaultBar;
      # package = pkgs.noctalia-shell;

      # TODO: settings & colors

      # settings = {};

      # colors = mapAttrs (_name: value: "#${value}") {
      #   mError = colors.bright.red;
      #   mHover = colors.bright.blue;
      #   mOnError = colors.background;
      #   mOnHover = colors.background;
      #   mOnPrimary = colors.background;
      #   mOnSecondary = colors.background;
      #   mOnSurface = "fbf1c7"; # fg0 (not mapped in colors yet)
      #   mOnSurfaceVariant = colors.foreground;
      #   mOnTertiary = colors.background;
      #   mOutline = "57514e"; # idk not in gruvbox spec
      #   mPrimary = colors.bright.green;
      #   mSecondary = colors.bright.yellow;
      #   mShadow = colors.background;
      #   mSurface = colors.background;
      #   mSurfaceVariant = colors.unfocused;
      #   mTertiary = colors.bright.blue;
      # };

      # plugins = {};
    };
  };
}
