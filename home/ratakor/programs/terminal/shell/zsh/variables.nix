{
  config,
  pkgs,
  lib,
  ...
}: let
  XDG_CONFIG_HOME = config.xdg.configHome;
  XDG_DATA_HOME = config.xdg.dataHome;
  XDG_CACHE_HOME = config.xdg.cacheHome;

  CARGO_HOME = "${XDG_DATA_HOME}/cargo";
  GOPATH = "${XDG_DATA_HOME}/go";
in {
  home = {
    # prepend extra directories to $PATH
    sessionPath = [
      # "$HOME/.local/bin"
      "${CARGO_HOME}/bin"
      "${GOPATH}/bin"
    ];

    # prepend extra directories to arbitrary PATH-like environment variables
    sessionSearchVariables = {
      MANPATH = ["$HOME/.local/share/man"];
      LD_LIBRARY_PATH = ["$HOME/.local/lib"];
    };

    sessionVariables = {
      # Default programs
      EDITOR = "nvim";
      # VISUAL = "nvim";
      TERMINAL = "footclient";
      # BROWSER = "cromite --new-window";
      DMENU = "tofi";

      # ~/ Clean-up
      FFMPEG_DATADIR = "${XDG_CONFIG_HOME}/ffmpeg";
      GNUPGHOME = "${XDG_DATA_HOME}/gnupg";
      inherit GOPATH;
      GOMODCACHE = "${XDG_CACHE_HOME}/go/mod";
      inherit CARGO_HOME;
      CARGO_TARGET_DIR = "${XDG_CACHE_HOME}/cargo";
      RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
      OPAMROOT = "${XDG_DATA_HOME}/opam";
      DOTNET_CLI_HOME = "${XDG_DATA_HOME}/dotnet";
      NUGET_PACKAGES = "${XDG_CACHE_HOME}/NuGetPackages";
      NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/npmrc";
      PYTHONSTARTUP = "${XDG_CONFIG_HOME}/python/pythonrc";
      PASSWORD_STORE_DIR = "${XDG_DATA_HOME}/pass";
      # W3M_DIR = "${XDG_STATE_HOME}/w3m";
      CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java";
      GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
      ZELLIJ_CONFIG_DIR = "${XDG_CONFIG_HOME}/zellij";
      ZELLIJ_CONFIG_FILE = "${XDG_CONFIG_HOME}/zellij/config.kdl";
      WINEPREFIX = "${XDG_DATA_HOME}/wine";

      # Disable telemetry (https://consoledonottrack.com)
      AZURE_CORE_COLLECT_TELEMETRY = "0";
      DO_NOT_TRACK = "1";
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      GATSBY_TELEMETRY_DISABLED = "1";
      POWERSHELL_TELEMETRY_OPTOUT = "1";
      SAM_CLI_TELEMETRY = "0";

      # Misc
      # GPG_TTY = "$(tty)";
      MOZ_ENABLE_WAYLAND = "1";
      MANWIDTH = "80";
      LESS = "-R";
      WEBKIT_DISABLE_DMABUF_RENDERER = "1";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
    };
  };
}
