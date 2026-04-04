{
  self,
  ...
}:
{
  hm.imports = [ "${self.pins.nix-index-database}/home-manager-module.nix" ];

  hm.programs = {
    # A file database for nixpkgs
    nix-index = {
      enable = true;
      # command-not-found.sh is decent but comma is better
      # enableZshIntegration = config.hm.programs.zsh.enable;
      # enableNushellIntegration = config.hm.programs.nushell.enable;
      symlinkToCacheHome = true;
    };
    # A combination of nix-index and nix run
    nix-index-database.comma.enable = true;
  };
}
