{
  imports = [
    ./grub.nix
    ./systemd-boot.nix
  ];

  boot = {
    loader = {
      timeout = 2;

      efi.canTouchEfiVariables = true;
    };
  };
}
