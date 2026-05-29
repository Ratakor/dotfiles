# GPG key management daemon
{ lib, pkgs, ... }:
let
  inherit (lib.time) secPerHour secPerYear;
in
{
  hm.services.gpg-agent = {
    enable = true;
    verbose = false; # default: false
    # Set $GPG_TTY=$(tty)
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableSshSupport = true;
    # sshKeys = [""]; # TODO: use self.keys
    defaultCacheTtl = 6 * secPerHour; # 6 hours
    defaultCacheTtlSsh = 6 * secPerHour; # 6 hours
    maxCacheTtl = 1 * secPerYear; # 1 year (default: 2 hours)
    maxCacheTtlSsh = 1 * secPerYear; # 1 year (default: 2 hours)
    # extraConfig = ''
    #   allow-preset-passphrase
    # '';
    # I'd rather have this than the ugly gnome3, gtk2 is fine too
    pinentry.package = pkgs.pinentry-qt;
  };
}
