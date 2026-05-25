{ config, pkgs, ... }:
let
  HOME = config.hm.home.homeDirectory;
  dprg = config.self.programs.default;
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
      projects = "${HOME}/repos"; # ig

      music = "${HOME}/media/music";
      pictures = "${HOME}/media/pictures";
      videos = "${HOME}/media/videos";

      # Non-standard
      extraConfig = {
        BIN = "${HOME}/.local/bin";
        SCREENSHOTS = "${config.hm.xdg.userDirs.pictures}/screenshots";
        NOTES = "${config.hm.xdg.userDirs.documents}/notes";
        # MAIL = "${HOME}/mail"; # ".local/var/mail" made sense with the .local convention
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
      # TODO: there should be an option corresponding to all these "pkgs" packages
      # Even though it's technically fine to include unused package,
      # they should still be removed as it takes a while to generate
      # the corresponding mimeapps.list (~30s atm).
      defaultApplicationPackages = builtins.filter (pkg: pkg != null) [
        pkgs.discord
        pkgs.spotify
        pkgs.qbittorrent
        pkgs.thunderbird
        (if config.hm.programs.anki.enable then config.hm.programs.anki.package else null)
        # order below is important
        dprg.editor.visual.package
        dprg.editor.package
        dprg.imageViewer.package
        config.hm.programs.mpv.package
        pkgs.zathura
        dprg.browser.package
      ];
    };
  };
}
