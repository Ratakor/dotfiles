{ config, ... }:
let
  inherit (builtins) listToAttrs;

  inherit (config.hm.home) homeDirectory;
in
{
  hm.xdg = {
    enable = true;

    # https://specifications.freedesktop.org/basedir-spec/latest
    configHome = "${homeDirectory}/.config";
    dataHome = "${homeDirectory}/.local/share";
    stateHome = "${homeDirectory}/.local/state";
    cacheHome = "${homeDirectory}/.cache";

    # .local convention
    # https://gist.github.com/Earnestly/84cf9670b7e11ae2eac6f753910efebe
    #configHome = "${homeDirectory}/.local/etc";
    #dataHome = "${homeDirectory}/.local/share";
    #stateHome = "${homeDirectory}/.local/var/state";
    #cacheHome = "${homeDirectory}/.local/var/cache";

    userDirs = {
      enable = true;
      createDirectories = true;

      download = "${homeDirectory}/tmp";
      desktop = null; # "${homeDirectory}/tmp";
      publicShare = null; # "${homeDirectory}/tmp";
      templates = null; # "${homeDirectory}/tmp";

      documents = "${homeDirectory}/documents";

      music = "${homeDirectory}/media/music";
      pictures = "${homeDirectory}/media/pictures";
      videos = "${homeDirectory}/media/videos";

      # Non-standard
      extraConfig = {
        XDG_BIN_HOME = "${homeDirectory}/.local/bin";

        XDG_SCREENSHOTS_DIR = "${config.hm.xdg.userDirs.pictures}/screenshots";
        XDG_NOTES_DIR = "${config.hm.xdg.userDirs.documents}/notes";
        # XDG_MAIL_DIR = "${homeDirectory}/mail"; # ".local/var/mail" made sense with the .local convention
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

    desktopEntries = {
      terminal-directory = {
        name = "File Manager";
        exec = "${config.self.terminal.cmdDir} %f";
        icon = "foot";
      };
      git = {
        name = "git";
        exec = "git clone %u";
        terminal = true;
      };
      torrent = {
        name = "Torrent Client";
        exec = "qbittorrent %u";
      };
    };

    mimeApps = {
      enable = true;
      defaultApplications =
        let
          browser = [ "chromium-browser.desktop" ]; # change to cromite when it's available

          # globbing is not supported in mimeapps.list
          # based on /usr/share/mime/types aka /run/current-system/sw/share/mime/types
          imageMimeTypes = [
            "image/apng"
            "image/astc"
            "image/avif"
            "image/bmp"
            "image/cgm"
            "image/dpx"
            "image/emf"
            "image/g3fax"
            "image/gif"
            "image/heif"
            "image/ief"
            "image/jp2"
            "image/jpeg"
            "image/jpm"
            "image/jpx"
            "image/jxl"
            "image/jxr"
            "image/ktx"
            "image/ktx2"
            "image/openraster"
            "image/png"
            "image/qoi"
            "image/rle"
            "image/svg+xml"
            "image/svg+xml-compressed"
            "image/tiff"
            "image/vnd.adobe.photoshop"
            "image/vnd.djvu"
            "image/vnd.djvu+multipage"
            "image/vnd.dwg"
            "image/vnd.dxf"
            "image/vnd.microsoft.icon"
            "image/vnd.ms-modi"
            "image/vnd.rn-realpix"
            "image/vnd.wap.wbmp"
            "image/vnd.zbrush.pcx"
            "image/webp"
            "image/wmf"
            "image/x-3ds"
            "image/x-adobe-dng"
            "image/x-applix-graphics"
            "image/x-bzeps"
            "image/x-canon-cr2"
            "image/x-canon-cr3"
            "image/x-canon-crw"
            "image/x-cmu-raster"
            "image/x-compressed-xcf"
            "image/x-dcraw"
            "image/x-dds"
            "image/x-dib"
            "image/x-eps"
            "image/x-exr"
            "image/x-fpx"
            "image/x-fuji-raf"
            "image/x-gimp-gbr"
            "image/x-gimp-gih"
            "image/x-gimp-pat"
            "image/x-gzeps"
            "image/x-icns"
            "image/x-ilbm"
            "image/x-jng"
            "image/x-jp2-codestream"
            "image/x-kodak-dcr"
            "image/x-kodak-k25"
            "image/x-kodak-kdc"
            "image/x-lwo"
            "image/x-lws"
            "image/x-macpaint"
            "image/x-minolta-mrw"
            "image/x-msod"
            "image/x-niff"
            "image/x-nikon-nef"
            "image/x-nikon-nrw"
            "image/x-olympus-orf"
            "image/x-panasonic-rw"
            "image/x-panasonic-rw2"
            "image/x-pentax-pef"
            "image/x-photo-cd"
            "image/x-pict"
            "image/x-portable-anymap"
            "image/x-portable-bitmap"
            "image/x-portable-graymap"
            "image/x-portable-pixmap"
            "image/x-quicktime"
            "image/x-rgb"
            "image/x-sgi"
            "image/x-sigma-x3f"
            "image/x-skencil"
            "image/x-sony-arw"
            "image/x-sony-sr2"
            "image/x-sony-srf"
            "image/x-sun-raster"
            "image/x-tga"
            "image/x-tiff-multipage"
            "image/x-win-bitmap"
            "image/x-xbitmap"
            "image/x-xcf"
            "image/x-xcursor"
            "image/x-xfig"
            "image/x-xpixmap"
            "image/x-xwindowdump"
          ];

          audioMimeTypes = [
            "audio/AMR"
            "audio/AMR-WB"
            "audio/aac"
            "audio/ac3"
            "audio/annodex"
            "audio/basic"
            "audio/flac"
            "audio/midi"
            "audio/mobile-xmf"
            "audio/mp2"
            "audio/mp4"
            "audio/mpeg"
            "audio/ogg"
            "audio/prs.sid"
            "audio/usac"
            "audio/vnd.audible.aax"
            "audio/vnd.audible.aaxc"
            "audio/vnd.dts"
            "audio/vnd.dts.hd"
            "audio/vnd.rn-realaudio"
            "audio/vnd.wave"
            "audio/webm"
            "audio/x-adpcm"
            "audio/x-aifc"
            "audio/x-aiff"
            "audio/x-amzxml"
            "audio/x-ape"
            "audio/x-dff"
            "audio/x-dsf"
            "audio/x-flac+ogg"
            "audio/x-gsm"
            "audio/x-iriver-pla"
            "audio/x-it"
            "audio/x-m4b"
            "audio/x-m4r"
            "audio/x-matroska"
            "audio/x-minipsf"
            "audio/x-mo3"
            "audio/x-mod"
            "audio/x-mpegurl"
            "audio/x-ms-asx"
            "audio/x-ms-wma"
            "audio/x-musepack"
            "audio/x-opus+ogg"
            "audio/x-pn-audibleaudio"
            "audio/x-psf"
            "audio/x-psflib"
            "audio/x-riff"
            "audio/x-s3m"
            "audio/x-scpls"
            "audio/x-speex"
            "audio/x-speex+ogg"
            "audio/x-stm"
            "audio/x-tak"
            "audio/x-tta"
            "audio/x-voc"
            "audio/x-vorbis+ogg"
            "audio/x-wavpack"
            "audio/x-wavpack-correction"
            "audio/x-xi"
            "audio/x-xm"
            "audio/x-xmf"
          ];

          videoMimeTypes = [
            "video/3gpp"
            "video/3gpp2"
            "video/annodex"
            "video/dv"
            "video/isivideo"
            "video/mj2"
            "video/mp2t"
            "video/mp4"
            "video/mpeg"
            "video/ogg"
            "video/quicktime"
            "video/vnd.avi"
            "video/vnd.mpegurl"
            "video/vnd.radgamettools.bink"
            "video/vnd.radgamettools.smacker"
            "video/vnd.rn-realvideo"
            "video/vnd.vivo"
            "video/vnd.youtube.yt"
            "video/wavelet"
            "video/webm"
            "video/x-anim"
            "video/x-flic"
            "video/x-flv"
            "video/x-javafx"
            "video/x-matroska"
            "video/x-matroska-3d"
            "video/x-mjpeg"
            "video/x-mng"
            "video/x-ms-wmv"
            "video/x-nsv"
            "video/x-ogm+ogg"
            "video/x-sgi-movie"
            "video/x-theora+ogg"
          ];

          textMimeTypes = [
            "text/x-shellscript"
            "text/plain"
          ];

          mimeToApps =
            types: apps:
            listToAttrs (
              map (type: {
                name = type;
                value = apps;
              }) types
            );
        in
        mimeToApps audioMimeTypes [ "mpv.desktop" ]
        // mimeToApps videoMimeTypes [ "mpv.desktop" ]
        // mimeToApps imageMimeTypes [ config.self.imageViewer.desktopEntry ]
        // mimeToApps textMimeTypes [ config.self.editor.desktopEntry ]
        // {
          "application/postscript" = [ "org.pwmt.zathura.desktop" ];
          "application/pdf" = [ "org.pwmt.zathura.desktop" ];
          "inode/directory" = [ "terminal-directory.desktop" ];
          "x-scheme-handler/git" = [ "git.desktop" ];
          "x-scheme-handler/magnet" = [ "torrent.desktop;" ];
          "application/x-bittorrent" = [ "torrent.desktop;" ];

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
