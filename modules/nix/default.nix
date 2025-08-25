{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.trivial) pipe;
  inherit (lib.types) isType;
  inherit (lib.attrsets) mapAttrsToList filterAttrs mapAttrs' nameValuePair;
in {
  imports = [
    ./documentation.nix
    ./nixpkgs.nix
  ];

  nix = {
    package = pkgs.nixVersions.latest; # pkgs.lix;

    # Remove nix-channel related tools & configs in favor of flakes
    channel.enable = false;

    # Pin the registry to avoid downloading and evaluating
    # a new nixpkgs version on each command causing a re-eval.
    # Also make flakes from this repo available with the nix CLI e.g.
    # `nix run config#custom-pkg` or `nix shell agenix`
    registry = let
      renameSelf = name:
        if name == "self"
        then "config"
        else name;
    in
      pipe inputs [
        (filterAttrs (_: isType "flake"))
        # (mapAttrs (_: flake: {inherit flake;}))
        (mapAttrs' (name: flake: nameValuePair (renameSelf name) {inherit flake;}))
      ];

    # Make legacy nix commands consistent with flakes
    # nixPath = mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    nixPath = mapAttrsToList (name: value: "${name}=${value.to.path}") config.nix.registry;

    # Customise /etc/nix/nix.conf declaratively
    # See nix.conf(5)
    settings = {
      # Give the users in this list the right to specify additional substituters via:
      #    1. `nixConfig.substituers` in `flake.nix`
      #    2. command line args `--options substituers http://xxx`
      trusted-users = ["@wheel"];

      # Enable flakes globally
      experimental-features = ["nix-command" "flakes"];

      substituters = [
        "https://nix-community.cachix.org"
        # "https://s3.cri.epita.fr/cri-nix-cache.s3.cri.epita.fr"
        # "https://nix-gaming.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "cache.nix.cri.epita.fr:qDIfJpZWGBWaGXKO3wZL1zmC+DikhMwFRO4RVE6VVeo="
        # "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];

      # Allow remote build machines to use their own substituters
      builders-use-substitutes = true;

      # Optimize storage
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      # Increases build time & useless with zfs dedup according to [insert forum link I forgot]
      auto-optimise-store = false; # TODO: set this to !config.zfs.enable or something

      # Move dotfiles in $HOME to $XDG_STATE_HOME/nix.
      # https://github.com/NixOS/nix/pull/5588
      use-xdg-base-directories = true;

      # Disable global flake registry
      flake-registry = "";

      # Remove warning about dirty VCS tree
      warn-dirty = false;

      nix-path = config.nix.nixPath;
    };

    # Perform garbage collection weekly to maintain low disk usage
    gc = {
      automatic = false; # handled by programs.nh.clean
      dates = "weekly";
      options = "--delete-older-than 1w";
      persistent = false;
    };
  };

  # nix helper
  programs.nh = {
    enable = true;
    clean = {
      enable = false; # idk if I want automatic cleaning actually
      extraArgs = "--keep 5 --keep-size 7d";
      dates = "weekly";
    };
    # flake = "/home/ratakor/nixos";
  };
}
