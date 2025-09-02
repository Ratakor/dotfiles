{
  imports = [
    ./services/libinput.nix
    ./services/tlp.nix
  ];

  system.nixos.tags = ["laptop"];
}
