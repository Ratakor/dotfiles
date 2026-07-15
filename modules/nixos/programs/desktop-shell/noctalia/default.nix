{
  config,
  lib,
  pkgs,
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
        toggle = "noctalia-shell ipc call bar toggle";
      };
      locker = mkIf (dprg.locker.name == "noctalia") {
        cmd = "noctalia-shell ipc call lockScreen lock";
      };
      powerMenu = mkIf (dprg.powerMenu.name == "noctalia") {
        cmd = "noctalia-shell ipc call sessionMenu toggle";
      };
    };

    hm.imports = [ sources.noctalia.homeModules.default ];

    hm.programs.noctalia = {
      enable = true;
      systemd.enable = isDefaultBar; # TODO: deprecated
      # package = pkgs.noctalia-shell;

      # settings = {};

      # colors = {
      #   mError = colors.bright.red;
      #   mHover = colors.bright.blue;
      #   mOnError = colors.background;
      #   mOnHover = colors.background;
      #   mOnPrimary = colors.background;
      #   mOnSecondary = colors.background;
      #   mOnSurface = "#fbf1c7"; # TODO: fg0
      #   mOnSurfaceVariant = colors.foreground;
      #   mOnTertiary = colors.background;
      #   mOutline = "#57514e";
      #   mPrimary = "#b8bb26";
      #   mSecondary = "#fabd2f";
      #   mShadow = "#282828";
      #   mSurface = "#282828";
      #   mSurfaceVariant = "#3c3836";
      #   mTertiary = "#83a598";
      # };

      # plugins = {};
    };
  };
}
