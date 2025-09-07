# GNU Privacy Guard
{config, ...}: {
  hm.programs.gpg = {
    enable = true;
    homedir = "${config.hm.xdg.dataHome}/gnupg"; # set $GNUPGHOME

    # Mutability, default: true
    mutableKeys = true;
    mutableTrust = true;

    settings = {
      # default-key = "";
      default-recipient-self = true;
      auto-key-locate = "local,wkd,keyserver";
      # keyserver is deprecated and should be set to dirmngr.conf instead
      keyserver = "hkps://keys.openpgp.org";
      auto-key-retrieve = true;
      auto-key-import = true;
      keyserver-options = "honor-keyserver-url";

      no-autostart = true;
    };
  };
}
