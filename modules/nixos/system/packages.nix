{
  pkgs,
  lib,
  self,
  ...
}:
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
      self.pkgs.helix-wrapped # editor, see environment.nix for $EDITOR
      yazi # file manager
      git
      # wget
      curl
      util-linux
      psmisc # see also the `killall` package

      ## shells
      ## They must be installed system-wide or it may cause issue when switching back-and-forth.
      zsh
      nushell

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
