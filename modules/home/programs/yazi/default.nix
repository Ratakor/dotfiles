# Terminal File Manager
{
  config,
  lib,
  pkgs,
  ...
}:
let
  yazi = pkgs.wrappers.yazi.override {
    ouch = pkgs.ouch-rar;
  };

  prg = config.self.programs;
in
{
  config = lib.mkIf prg.fileManager.yazi.enable {
    user.packages = [ yazi ];

    hm.programs.yazi = {
      enable = true;
      package = null; # We use our custom wrapped package.
      shellWrapperName = "y";
      # Add a shell wrapper (`y`) that changes cwd when exiting yazi
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
