{
  imports = [
    ./services/xserver.nix
  ];

  system.nixos.tags = ["graphical"];
}
