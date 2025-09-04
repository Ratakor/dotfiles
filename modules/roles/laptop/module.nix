{
  imports = [
    ./services/libinput.nix
    ./services/watt.nix
  ];

  system.nixos.tags = ["laptop"];
}
