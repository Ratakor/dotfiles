{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.meta) getExe;

  XDG_CONFIG_HOME = config.hm.xdg.configHome;
  XDG_DATA_HOME = config.hm.xdg.dataHome;
  XDG_CACHE_HOME = config.hm.xdg.cacheHome;
  XDG_STATE_HOME = config.hm.xdg.stateHome;

  CARGO_HOME = "${XDG_DATA_HOME}/cargo";
  GOPATH = "${XDG_DATA_HOME}/go";
in {
  hm.home = {
    # prepend extra directories to $PATH
    sessionPath = [
      # "$HOME/.local/bin"
      "${CARGO_HOME}/bin"
      "${GOPATH}/bin"
    ];

    # prepend extra directories to arbitrary PATH-like environment variables
    sessionSearchVariables = {
      # smh this overwrite default MANPATH
      # MANPATH = ["${XDG_DATA_HOME}/man"];

      # LD_LIBRARY_PATH = ["$HOME/.local/lib"];
      # TERMINFO_DIRS = ["${XDG_DATA_HOME}/terminfo" "/usr/share/terminfo"]
    };

    sessionVariables = {
      # Default programs
      EDITOR = "nvim";
      # VISUAL = "nvim"; # nvim is not a visual editor
      BROWSER = "chromium --new-window"; # cromite

      ## Wayland
      TERMINAL = "footclient";
      DMENU = "tofi";

      ## X11
      # TERMINAL = "st";
      # DMENU = "dmenu -i";

      # ~/ Clean-up
      FFMPEG_DATADIR = "${XDG_CONFIG_HOME}/ffmpeg";
      inherit GOPATH;
      GOMODCACHE = "${XDG_CACHE_HOME}/go/mod";
      inherit CARGO_HOME;
      CARGO_TARGET_DIR = "${XDG_CACHE_HOME}/cargo";
      RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
      OPAMROOT = "${XDG_DATA_HOME}/opam";
      DOTNET_CLI_HOME = "${XDG_DATA_HOME}/dotnet";
      NUGET_PACKAGES = "${XDG_CACHE_HOME}/NuGetPackages";
      NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/npmrc";
      PYTHON_HISTORY = "${XDG_STATE_HOME}/python_history";
      PASSWORD_STORE_DIR = "${XDG_DATA_HOME}/pass";
      W3M_DIR = "${XDG_STATE_HOME}/w3m";
      CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java";
      GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
      WINEPREFIX = "${XDG_DATA_HOME}/wine";
      # TERMINFO = "${XDG_DATA_HOME}/terminfo";
      DOOMWADDIR = "${XDG_DATA_HOME}/gzdoom";

      # Disable telemetry (https://consoledonottrack.com)
      AZURE_CORE_COLLECT_TELEMETRY = "0";
      DO_NOT_TRACK = "1";
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      GATSBY_TELEMETRY_DISABLED = "1";
      POWERSHELL_TELEMETRY_OPTOUT = "1";
      SAM_CLI_TELEMETRY = "0";

      # Misc
      MOZ_ENABLE_WAYLAND = "1";
      MANWIDTH = "80";
      LESS = "-R";
      WEBKIT_DISABLE_DMABUF_RENDERER = "1";
      MANPAGER = "sh -c 'col -bx | ${getExe pkgs.bat} -l man -p'";
      MANROFFOPT = "-c";
    };
  };
}
