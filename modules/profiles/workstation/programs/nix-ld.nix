{
  programs.nix-ld = {
    enable = true;
    # libraries = with pkgs; [
    #   # default
    #   zlib
    #   zstd
    #   stdenv.cc.cc
    #   curl
    #   openssl
    #   attr
    #   libssh
    #   bzip2
    #   libxml2
    #   acl
    #   libsodium
    #   util-linux
    #   xz
    #   systemd

    #   glib
    #   glibc
    #   icu
    #   libunwind
    #   libuuid
    #   libsecret

    #   # graphical
    #   freetype
    #   libglvnd
    #   libnotify
    #   SDL2
    #   vulkan-loader
    #   gdk-pixbuf
    #   libx11
    # ];
  };
}
