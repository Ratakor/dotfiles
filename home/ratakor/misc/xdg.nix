# TODO: missing custom entries
{config, ...}: let
  browser = ["chromium.desktop"]; # TODO: change to cromite?

  # XDG MIME types
  associations = {
    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.desktop"];
    "image/*" = ["imv.desktop"];
    # "text/x-shellscript" = ["text.desktop"];
    # "text/plain" = ["text.desktop"];
    # "application/postscript" = ["pdf.desktop"];
    # "application/pdf" = ["pdf.desktop"]; # ["org.pwmt.zathura.desktop.desktop"];
    # "inode/directory" = ["file.desktop"];
    # "x-scheme-handler/ircs" = ["senpai.desktop"];
    # "x-scheme-handler/irc" = ["senpai.desktop"];
    # "x-scheme-handler/git" = ["git.desktop"];
    # "x-scheme-handler/magnet" = ["torrent.desktop;"];
    # "application/x-bittorrent" = ["torrent.desktop;"];

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

    # "x-scheme-handler/mailto" = ["mail.desktop"];
    # "x-scheme-handler/discord" = ["discord.desktop"];
    # "x-scheme-handler/spotify" = ["spotify.desktop"];

    # anki.desktop is automatically created by anki
    # application/x-colpkg=anki.desktop
    # application/x-apkg=anki.desktop
    # application/x-ankiaddon=anki.desktop
  };
in {
  xdg = {
    enable = true;

    cacheHome = "${config.home.homeDirectory}/.local/var/cache";
    configHome = "${config.home.homeDirectory}/.local/etc";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/var/state";

    # Make npm and python respect XDG directories
    configFile = {
      "npm/npmrc".text = ''
        prefix=${config.xdg.dataHome}/npm
        cache=${config.xdg.cacheHome}/npm
        init-module=${config.xdg.configHome}/npm/config/npm-init.js
      '';

      "python/pythonrc".text = ''
        import os
        import atexit
        import readline
        from pathlib import Path

        if readline.get_current_history_length() == 0:

            state_home = os.environ.get("XDG_STATE_HOME")
            if state_home is None:
                state_home = Path.home() / ".local" / "state"
            else:
                state_home = Path(state_home)

            history_path = state_home / "python_history"
            if history_path.is_dir():
                raise OSError(f"'{history_path}' cannot be a directory")

            history = str(history_path)

            try:
                readline.read_history_file(history)
            except OSError: # Non existent
                pass

            def write_history():
                try:
                    readline.write_history_file(history)
                except OSError:
                    pass

            atexit.register(write_history)
      '';
    };

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
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
