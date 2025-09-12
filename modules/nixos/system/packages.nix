{
  pkgs,
  lib,
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
    # TODO: sort that
    systemPackages = with pkgs; [
      neovim # editor
      yazi # file manager
      git
      less
      wget
      curl
      rsync

      lvm2
      cryptsetup
      sysfsutils
      #ntfs3g
      #xfsprogs xfsdump
      killall
      gnupg
      pkg-config
      xdg-utils

      ## system tools
      # sysstat
      lm_sensors # sensors
      pciutils # lspci
      usbutils # lsusb
      dnsutils # dig, host, nslookup
      brightnessctl # brightness control

      ## parabola base
      file
      findutils
      gawk
      gcc
      gettext
      glibc
      gnugrep
      gzip
      iproute2
      iputils
      procps
      psmisc
      gnused
      shadow
      gnutar
      util-linux
      xz

      ## parabola base-devel
      autoconf
      automake
      binutils
      bison
      debugedit
      fakeroot
      flex
      groff
      libtool
      m4
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
