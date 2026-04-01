# Terminal File Manager
{ config, self, ... }:
{
  user.packages = [ self.pkgs.yazi-wrapped ];

  hm.programs.yazi = {
    enable = true;
    package = null; # We use our custom wrapped package.
    shellWrapperName = "y";
    # Add a shell wrapper (`y`) that changes cwd when exiting yazi
    enableZshIntegration = config.hm.programs.zsh.enable;
  };
}
