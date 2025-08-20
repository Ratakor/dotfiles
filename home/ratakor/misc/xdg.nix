# https://gist.github.com/Earnestly/84cf9670b7e11ae2eac6f753910efebe
{config, ...}: {
  home.preferXdgDirectories = true; # doesn't do much

  xdg = {
    enable = true;

    configHome = "${config.home.homeDirectory}/.local/etc";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/var/state"; # could be named log or lib too
    cacheHome = "${config.home.homeDirectory}/.local/var/cache";

    userDirs = {
      enable = true;
      createDirectories = true;

      download = "${config.home.homeDirectory}/tmp";
      desktop = null; # "${config.home.homeDirectory}/tmp";
      publicShare = null; # "${config.home.homeDirectory}/tmp";
      templates = null; # "${config.home.homeDirectory}/tmp";

      documents = "${config.home.homeDirectory}/media/doc";
      music = "${config.home.homeDirectory}/media/music";
      pictures = "${config.home.homeDirectory}/media/pictures";
      videos = "${config.home.homeDirectory}/media/videos";

      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/screenshots";
        XDG_MAIL_DIR = "${config.home.homeDirectory}/.local/var/mail";
      };
    };

    # Make some software respect XDG directories
    configFile = {
      "npm/npmrc".text = ''
        prefix=${config.xdg.dataHome}/npm
        cache=${config.xdg.cacheHome}/npm
        init-module=${config.xdg.configHome}/npm/config/npm-init.js
      '';

      "pulse/client.conf".text = ''
        cookie-file = ${config.xdg.configHome}/pulse/cookie
      '';
    };

    desktopEntries = {
      file = {
        name = "File Manager";
        exec = "footclient -D %f";
      };
      git = {
        name = "git";
        exec = "footclient -e git clone %u";
      };
      mail = {
        name = "Mail Client";
        exec = "mail --compose %u";
      };
      text = {
        name = "Text Editor";
        exec = "footclient -e nvim %u";
      };
      torrent = {
        name = "Torrent Client";
        exec = "qbittorrent %u";
      };
    };

    mimeApps = {
      enable = true;
      defaultApplications = let
        browser = ["chromium-browser.desktop"]; # TODO: change to cromite?
      in {
        "audio/*" = ["mpv.desktop"];
        "video/*" = ["mpv.desktop"];
        "image/*" = ["imv.desktop"];
        "text/x-shellscript" = ["text.desktop"];
        "text/plain" = ["text.desktop"];
        "application/postscript" = ["org.pwmt.zathura.desktop"];
        "application/pdf" = ["org.pwmt.zathura.desktop"];
        "inode/directory" = ["file.desktop"];
        # "x-scheme-handler/ircs" = ["senpai.desktop"];
        # "x-scheme-handler/irc" = ["senpai.desktop"];
        "x-scheme-handler/git" = ["git.desktop"];
        "x-scheme-handler/magnet" = ["torrent.desktop;"];
        "application/x-bittorrent" = ["torrent.desktop;"];

        "text/html" = browser;
        "x-scheme-handler/ftp" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
        # "application/json" = browser;
        "application/xhtml+xml" = browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;

        # TODO
        # "x-scheme-handler/mailto" = ["mail.desktop"];
        # "x-scheme-handler/discord" = ["discord.desktop"];
        # "x-scheme-handler/spotify" = ["spotify.desktop"];

        # anki.desktop is automatically created by anki
        # application/x-colpkg=anki.desktop
        # application/x-apkg=anki.desktop
        # application/x-ankiaddon=anki.desktop
      };
    };
  };
}
