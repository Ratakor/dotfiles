{
  lib,
  config,
  ...
}: {
  imports = [
    ./programs
    ./misc
  ];

  # TODO: this shouldn't be here + it's ugly
  # https://librephoenix.com/2023-12-26-nixos-conditional-config-and-custom-options
  options = {
    # https://github.com/nix-community/home-manager/issues/2085#issuecomment-2022239332
    # https://foodogsquared.one/posts/2023-03-24-managing-mutable-files-in-nixos/
    home.dotfiles = lib.mkOption {
      type = lib.types.path;
      apply = config.lib.file.mkOutOfStoreSymlink;
      default = "${config.home.homeDirectory}/nixos";
      example = "${config.home.homeDirectory}/nixos";
      description = "Location of the dotfiles working copy";
    };
  };

  config = {
    home = rec {
      username = "ratakor";
      homeDirectory = "/home/${username}";
      stateVersion = "25.05";

      dotfiles = "${homeDirectory}/nixos/home/ratakor";
    };

    # Allow HM to manage itself when in standalone mode.
    # This makes the home-manager command available to users.
    programs.home-manager.enable = true;
  };
}
