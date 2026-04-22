{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib.attrsets) mapAttrsToList;
in
{
  imports = [
    # ./builders.nix
    ./documentation.nix
    ./nixpkgs.nix
  ];

  nix = {
    # package = pkgs.lix; # lix doesn't support pipe operators
    package = pkgs.nixVersions.latest;

    # Remove nix-channel related tools & configs in favor of flakes
    channel.enable = false;

    # Pin the registry to avoid downloading and evaluating
    # a new nixpkgs version on each command causing a re-eval.
    # Also make flakes from this repo available with the nix CLI e.g.
    # `nix run self#custom-pkg` or `nix shell agenix`
    registry = {
      self.flake = self;
      # idk how but nixpkgs is already included in my config :D
    };

    # Make legacy nix commands consistent with flakes
    nixPath = mapAttrsToList (name: value: "${name}=${value.to.path}") config.nix.registry;

    # Customise /etc/nix/nix.conf declaratively
    # See nix.conf(5)
    settings = {
      # Give the users in this list the right to specify additional substituters via:
      #    1. `nixConfig.substituers` in `flake.nix`
      #    2. command line args `--options substituers http://xxx`
      trusted-users = [ "@wheel" ];

      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
        "cgroups"
      ];

      extra-substituters = [
        "https://ratakor.cachix.org"
        "https://nix-community.cachix.org"
        "https://s3.cri.epita.fr/cri-nix-cache.s3.cri.epita.fr"
        # "https://nix-gaming.cachix.org"
      ];

      extra-trusted-public-keys = [
        "ratakor.cachix.org-1:9hOGzHtnKDJ1i9FQN87XFnOOpRBebSKWECswk17glP0="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nix.cri.epita.fr:qDIfJpZWGBWaGXKO3wZL1zmC+DikhMwFRO4RVE6VVeo="
        # "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];

      # Allow remote build machines to use their own substituters
      builders-use-substitutes = true;

      # Optimize storage
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      # Increases build time & useless with zfs dedup according to [insert forum link I forgot]
      auto-optimise-store = false; # config.fileSystems."/nix".fsType != "zfs";

      # Move dotfiles in $HOME to $XDG_STATE_HOME/nix.
      # https://github.com/NixOS/nix/pull/5588
      use-xdg-base-directories = true;

      # Disable global flake registry.
      flake-registry = "";

      # Remove warning about dirty VCS tree
      warn-dirty = false;

      # Whether  to  accept  Nix  configuration settings from a flake without prompting.
      # Default: false
      accept-flake-config = false; # I really want to set this to true

      # Whether to execute builds inside cgroups.
      use-cgroups = pkgs.stdenv.isLinux; # This is only supported on Linux.

      # The timeout (in seconds) for establishing connections with a substituter.
      connect-timeout = 5; # default: 15
    };

    # Perform garbage collection weekly to maintain low disk usage
    gc = {
      automatic = false; # handled by programs.nh.clean
      dates = "weekly";
      options = "--delete-older-than 1w";
      persistent = false;
    };

    # Automatically run the nix store optimiser at a specific time.
    optimise = {
      automatic = true;
      dates = [ "04:00" ];
      persistent = false; # should prevent from running at init
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
    # Set NH_FLAKE env variable for the default flake path.
    # flake = "/home/${config.self.username}/nixos";
  };
}
