{ config, ... }:
{
  # nix helper
  programs.nh = {
    enable = true;

    clean = {
      enable = false; # idk if I want automatic cleaning actually
      extraArgs = "--keep 5 --keep-size 7d";
      dates = "weekly";
    };

    # Set NH_FLAKE env variable for the default flake path.
    flake = "${config.user.home}/nixos";
  };
}
