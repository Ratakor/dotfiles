# Terminal File Manager
{ pkgs, self, ... }:
let
  yazi = self.pkgs.yazi-wrapped.override {
    ouch = pkgs.ouch-rar;
  };
in
{
  user.packages = [ yazi ];

  hm.programs.yazi = {
    enable = true;
    package = null; # We use our custom wrapped package.
    shellWrapperName = "y";
    # Add a shell wrapper (`y`) that changes cwd when exiting yazi
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };
}
