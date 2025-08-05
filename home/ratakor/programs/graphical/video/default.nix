{
  config,
  pkgs,
  ...
}: {
  # TODO: probably move that to a specific "music.nix" file
  home = {
    # dependency for the music script that uses mpv
    packages = [pkgs.socat];

    file."${config.xdg.configHome}/mpv/music" = {
      source = ./music;
      recursive = true;
    };
  };

  home.file."${config.xdg.configHome}/mpv/scripts" = {
    source = ./scripts;
    recursive = true;
  };

  programs = {
    mpv = {
      enable = true;
      # defaultProfiles = ["gpu-hq"];
      bindings = {
        WHEEL_UP = "add volume 2";
        WHEEL_DOWN = "add volume -2";
        l = "seek 5";
        h = "seek -5";
        j = "seek 60";
        k = "seek -60";
      };
      scripts = with pkgs.mpvScripts; [
        reload
        sponsorblock-minimal
        # skipsilence
        # mpv-notify-send
      ];
    };

    # TODO
    obs-studio = {
      enable = false;
    };
  };
}
