# TODO
{
  config,
  ...
}: let
  browser = ["firefox.desktop"];

  # XDG MIME types
  associations = {
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    "text/html" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/chrome" = ["chromium-browser.desktop"];
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;

    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.desktop"];
    "image/*" = ["imv.desktop"];
    "application/json" = browser;
    "application/pdf" = ["org.pwmt.zathura.desktop.desktop"];
    "x-scheme-handler/discord" = ["discordcanary.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
  };
in {
  xdg = {
    enable = true;

    cacheHome = "${config.home.homeDirectory}/.local/var/cache";
    configHome = "${config.home.homeDirectory}/.local/etc";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/var/state";

    userDirs = {
      enable = true;
      createDirectories = true;

      download = "${config.home.homeDirectory}/tmp";
      desktop = null; # "${config.home.homeDirectory}/tmp";
      publicShare = null; # "${config.home.homeDirectory}/tmp";
      templates = null; # "${config.home.homeDirectory}/tmp";

      documents = "${config.home.homeDirectory}/media/doc";
      music = "${config.home.homeDirectory}/media/music";
      pictures = "${config.home.homeDirectory}/media/pic";
      videos = "${config.home.homeDirectory}/media/vid";

      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/screenshots";
        # XDG_MAIL_DIR = "${config.home.homeDirectory}/mail";
      };
    };

    mimeApps = {
      enable = true;
      # associations.added = associations;
      defaultApplications = associations;
    };
  };
}
