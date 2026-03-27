{
  imports = [
    ./services/libinput.nix
    ./services/upower.nix
    # ./services/watt.nix
  ];

  system.nixos.tags = [ "laptop" ];
}
