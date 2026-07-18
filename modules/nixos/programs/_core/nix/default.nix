{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib.strings) getName;
in
{
  nix = {
    # Nix package is already set in a nixpkgs overlay.
    # Look at flake/pkgs/pkgs.nix for the whole nixpkgs config.
    # package = pkgs.lixPackageSets.latest.lix;
    # package = pkgs.nixVersions.latest;

    # Remove nix-channel related tools & configs in favor of flakes (tack)
    channel.enable = false;

    # Replace nixpkgs with this flake's instance of legacyPackages
    # that includes all the cool kids overlays.
    # See also config.nixpkgs.flake and config.nix.registry.nixpkgs.flake.
    registry.nixpkgs.to = {
      type = "path";
      path = self;
    };

    # Make legacy nix commands consistent with flakes
    # nixPath = mapAttrsToList (name: value: "${name}=${value.to.path}") config.nix.registry;
    # nixPath = mapAttrsToList (name: value: "${name}=flake:${name}") config.nix.registry;
    nixPath = [
      "nixpkgs=${
        pkgs.runCommandLocal "nixpkgs" { } ''
          mkdir -p "$out"
          cat << EOF > "$out/default.nix"
          {...}@args: (import ${toString self} args).legacyPackages.\''${builtins.currentSystem}
          EOF
        ''
      }"
    ];

    # Customise /etc/nix/nix.conf declaratively
    # See nix.conf(5)
    settings = {
      # Users allowed to connect to the Nix daemon.
      allowed-users = [ "@wheel" ]; # default: "*"

      # Users allowed to specify additional substituters
      trusted-users = [ "root" ];

      experimental-features = [
        "nix-command"
        "flakes"
        (if (getName config.nix.package) == "lix" then "pipe-operator" else "pipe-operators")
        "cgroups"
      ];

      substituters = [
        "https://cache.nixos.org/"
        "https://ratakor.cachix.org"
        "https://nix-community.cachix.org"
        # "https://s3.cri.epita.fr/cri-nix-cache.s3.cri.epita.fr"
        # "https://nix-gaming.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "ratakor.cachix.org-1:9hOGzHtnKDJ1i9FQN87XFnOOpRBebSKWECswk17glP0="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "cache.nix.cri.epita.fr:qDIfJpZWGBWaGXKO3wZL1zmC+DikhMwFRO4RVE6VVeo="
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

      # Remove warning about dirty VCS tree.
      warn-dirty = false;

      # Whether to accept Nix configuration settings from a flake without prompting.
      # Massive security vulnerability.
      accept-flake-config = false;

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
}
