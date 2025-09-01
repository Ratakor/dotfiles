{
  keys, # TODO: add to gpg to parts/keys.nix for default-key and sshKeys
  pkgs,
  self,
  ...
}: let
  inherit (self.lib.time) secPerHour secPerYear;
in {
  services.gpg-agent = {
    enable = true;
    verbose = false; # default: false
    enableZshIntegration = true; # set $GPG_TTY=$(tty)
    enableSshSupport = true;
    # sshKeys = [""];
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
