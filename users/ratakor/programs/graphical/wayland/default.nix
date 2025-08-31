{
  imports = [
    ./window-manager # Window Manager
    ./launcher # App launcher / Dynamic Menu
    ./misc.nix

    ./foot.nix # Terminal emulator
    ./swaylock.nix # Screen locker
    ./waybar # Status bar
    ./wlogout.nix # Logout menu
  ];
}
