{ config, ... }:
let
  HOME = config.hm.home.homeDirectory;
  prg = config.self.programs;
  dprg = prg.default;
in
{
  hm.xdg = {
    enable = true;

    # https://specifications.freedesktop.org/basedir-spec/latest
    configHome = "${HOME}/.config";
    dataHome = "${HOME}/.local/share";
    stateHome = "${HOME}/.local/state";
    cacheHome = "${HOME}/.cache";

    # .local convention
    # https://gist.github.com/Earnestly/84cf9670b7e11ae2eac6f753910efebe
    #configHome = "${HOME}/.local/etc";
    #dataHome = "${HOME}/.local/share";
    #stateHome = "${HOME}/.local/var/state";
    #cacheHome = "${HOME}/.local/var/cache";

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;

      download = "${HOME}/tmp";
      desktop = null; # "${HOME}/tmp";
      publicShare = null; # "${HOME}/tmp";
      templates = null; # "${HOME}/tmp";

      documents = "${HOME}/documents";
      projects = "${HOME}/projects";

      music = "${HOME}/media/music";
      pictures = "${HOME}/media/pictures";
      videos = "${HOME}/media/videos";

      # Non-standard
      extraConfig = {
        BIN = "${HOME}/.local/bin";
        NOTES = "${config.hm.xdg.userDirs.documents}/notes";
        # MAIL = "${HOME}/mail"; # ".local/var/mail" made sense with the .local convention
        SCREENSHOTS = "${config.hm.xdg.userDirs.pictures}/screenshots";
        WALLPAPERS = "${config.hm.xdg.userDirs.pictures}/wallpapers";
      };
    };

    # Make some software respect XDG directories
    configFile = {
      "npm/npmrc".text = ''
        prefix=${config.hm.xdg.dataHome}/npm
        cache=${config.hm.xdg.cacheHome}/npm
        init-module=${config.hm.xdg.configHome}/npm/config/npm-init.js
      '';

      "pulse/client.conf".text = ''
        cookie-file = ${config.hm.xdg.configHome}/pulse/cookie
      '';
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ dprg.fileManager.desktopEntry ];
      };
      # This takes ~30s to generate mimeapps.list but I love it.
      defaultApplicationPackages = builtins.filter (pkg: pkg != null) [
        prg.apps.discord.package
        prg.apps.spotify.package
        prg.apps.qbittorrent.package
        dprg.email.package
        prg.apps.anki.package
        # order below is important
        dprg.editor.package
        dprg.imageViewer.package
        dprg.mediaPlayer.package
        dprg.documentViewer.package
        dprg.browser.package
      ];
    };
  };
}
