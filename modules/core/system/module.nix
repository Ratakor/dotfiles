{
  # See .github/workflows/update.yml
  system.autoUpgrade.enable = false;

  imports = [
    ./console.nix
    ./environment.nix
    ./locale.nix
    ./networking.nix
    ./packages.nix
  ];
}
