{ pkgs, lib, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  environment = {
    # Disable NixOS default packages.
    defaultPackages = mkForce [ ];

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    systemPackages = with pkgs; [
      wrappers.helix # editor, see environment.nix for $EDITOR
      yazi # file manager
      git
      # wget
      curl
      util-linux
      psmisc # see also the `killall` package

      ## system tools
      # sysstat
      lm_sensors # sensors
      pciutils # lspci
      usbutils # lsusb
      dnsutils # dig, host, nslookup
      brightnessctl # brightness control
      procps # ps

      ## Linux man pages
      man-pages
      man-pages-posix
    ];
  };
}
