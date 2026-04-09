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
    # TODO: sort/cleanup that
    systemPackages = with pkgs; [
      self.pkgs.helix-wrapped # editor, see environment.nix for $EDITOR
      yazi # file manager
      git
      # wget
      curl

      # shells
      # They must be installed system-wide or it may cause issue when switching back-and-forth.
      zsh
      nushell

      lvm2
      cryptsetup
      sysfsutils
      #ntfs3g
      #xfsprogs xfsdump
      gnupg
      pkg-config

      ## system tools
      # sysstat
      lm_sensors # sensors
      pciutils # lspci
      usbutils # lsusb
      dnsutils # dig, host, nslookup
      brightnessctl # brightness control
      procps # ps

      ## parabola base
      file
      findutils
      gawk
      glibc
      gnugrep
      psmisc # see also the `killall` package
      gnused
      util-linux

      ## parabola base-devel
      binutils
      groff
      gnumake
      patch
      pkgconf
      texinfo
      which

      ## Linux man pages
      man-pages
      man-pages-posix
    ];
  };
}
