{
  config,
  pkgs,
  sources,
  ...
}:
let
  module = "${sources.noctalia-shell}/nix/home-module.nix";

  # colors = config.self.colors.default;
  prg = config.self.programs;
  dprg = prg.default;
in
{
  hm.imports = [ module ];

  hm.programs.noctalia-shell = {
    enable = prg.statusBar.noctalia.enable;
    systemd.enable = dprg.default.statusBar.name == "noctalia"; # TODO: deprecated
    package = pkgs.noctalia-shell;

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
}
