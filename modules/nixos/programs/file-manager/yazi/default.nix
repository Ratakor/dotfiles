# Terminal File Manager
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  yazi = pkgs.wrappers.yazi.override {
    ouch = pkgs.ouch-rar;
  };

  prg = config.self.programs;
in
{
  config = mkIf prg.fileManager.yazi.enable {
    self.programs.default.fileManager = mkIf (prg.default.fileManager.name == "yazi") {
      desktopEntry = "yazi.desktop";
    };

    user.packages = [ yazi ];

    hm.programs.yazi = {
      enable = true;
      package = null; # We use our custom wrapped package.
      shellWrapperName = "y";
      # Add a shell wrapper (`y`) that changes cwd when exiting yazi
      enableZshIntegration = true;
    };
  };
}
