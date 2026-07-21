{
  config,
  lib,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf;

  defaultName = "noctalia";

  # colors = config.self.colors.default;
  prg = config.self.programs;
  dprg = prg.default;
  isDefaultBar = dprg.statusBar.name == defaultName;
  isDefaultLauncher = dprg.launcher.name == defaultName;
in
{
  config = mkIf prg.desktopShell.noctalia.enable {
    self.programs.default = {
      statusBar = mkIf isDefaultBar {
        toggle = "noctalia msg bar-toggle";
      };
      locker = mkIf (dprg.locker.name == defaultName) {
        cmd = "noctalia msg session lock";
      };
      powerMenu = mkIf (dprg.powerMenu.name == defaultName) {
        cmd = "noctalia msg panel-toggle session";
        # cmd = "noctalia msg panel-toggle launcher '/session '";
      };
      launcher = mkIf isDefaultLauncher {
        dmenu = "fuzzel --dmenu";
        drun = "noctalia msg panel-toggle launcher";
        run = "noctalia msg panel-toggle launcher"; # no equivalent?
      };
    };

    # fuzzel is used as a fallback launcher for dmenu mode
    self.programs.launcher.fuzzel.enable = isDefaultLauncher;

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
