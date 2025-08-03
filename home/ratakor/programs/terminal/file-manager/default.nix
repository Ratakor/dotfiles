{
  pkgs,
  ...
}: {
  # yazi dependencies
  home.packages = with pkgs; [
    ouch
    poppler
    mediainfo
    ffmpegthumbnailer
  ];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    initLua = ./init.lua;

    keymap.mgr.prepend_keymap = [
      { on = "l"; run = "plugin bypass smart-enter"; desc = "Open a file, or recursively enter child directory, skipping children with only a single subdirectory"; }
      { on = "h"; run = "plugin bypass reverse"; desc = "Recursively enter parent directory, skipping parents with only a single subdirectory"; }
      { on = "p"; run = "plugin --sync smart-paste"; desc = "Paste into the hovered directory or CWD"; }
      { on = "T"; run = "plugin --sync hide-preview"; desc = "Hide or show preview"; }
      { on = "<C-n>"; run = "shell 'dragon-drop -x -T \"$1\"' --confirm "; }
      { on = [ "g" "c" ]; run = "cd $XDG_CONFIG_HOME"; desc = "Go to the config directory"; }
      { on = [ "g" "d" ]; run = "cd $XDG_DOWNLOAD_DIR"; desc = "Go to the downloads directory"; }
      { on = "<backspace>"; run = "remove"; desc = "Trash selected files"; }
      { on = "o"; run = "shell 'plumber \"$1\"' --confirm"; desc = "Open selected files"; }
      { on = "<Enter>"; run = "shell 'plumber \"$1\"' --confirm"; desc = "Open selected files"; }
      { on = "w"; run = "shell 'env IGNORE=\"\" randwp \"$1\"' --confirm"; desc = "Set wallpaper"; }
      { on = "W"; run = "tasks_show"; desc = "Show task manager"; }
      { on = "<C-z>"; run = "noop"; }
      { on = "C"; run = "plugin ouch zip"; desc = "Compress with ouch"; }
    ];

    plugins = with pkgs.yaziPlugins; {
      inherit bypass;
      inherit mediainfo;
      inherit ouch;
      inherit smart-paste;
      inherit toggle-pane;
      man = ./plugins/man.yazi;
      text = ./plugins/text.yazi;
    };

    settings = {
      mgr = {
        ratio = [ 1 4 3 ];
        sort_by = "natural";
        scrolloff = 0;
        mouse_events = [ "click" "scroll" "move" "drag" ];
      };
      preview = {
        tab_size = 8;
        cache_dir = "$XDG_CACHE_HOME/yazi";
        # image_delay = 0;
      };
      plugin.prepend_previewers = [
        { mime = "text/troff"; run = "man"; }
        { mime = "text/*"; run = "text"; }
        { mime = "{image,audio,video}/*"; run = "mediainfo"; }
        { mime = "application/x-subrip"; run = "mediainfo"; }
        { mime = "application/*zip"; run = "ouch"; }
        { mime = "application/x-tar"; run = "ouch"; }
        { mime = "application/x-bzip{,2}"; run = "ouch"; }
        { mime = "application/x-7z-compressed"; run = "ouch"; }
        { mime = "application/x-rar"; run = "ouch"; }
        { mime = "application/x-xz"; run = "ouch"; }
        { mime = "application/zstd"; run = "ouch"; }
        # *opendocument*) odt2txt "$1" ;;
        # application/pgp-encrypted) gpg -d -- "$1" ;;
      ];
    };

    # theme = {}; # TODO
  };
}
