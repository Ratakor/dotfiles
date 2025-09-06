{
  imports = [
    ./borgmatic.nix # Backup tool
    ./gammastep.nix # Screen color temperature adjuster
    ./gpg-agent.nix # GPG key management daemon
    ./syncthing.nix # File synchronization tool
    ./udiskie.nix # USB device manager (auto-mounting)
  ];
}
