{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) readFile;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  inherit (lib.trivial) hexToRgba;

  colors = config.self.colors.default;
  opacity = {
    fg = 1.0;
    bg = 0.75; # 0.75 is better with xray (niri), 0.85 otherwise
  };

  # https://github.com/abenz1267/walker#basic-usage
  fastSocketCall = "${getExe pkgs.netcat} -U /run/user/${toString config.user.uid}/walker/walker.sock";

  prg = config.self.programs;
in
{
  config = mkIf prg.launcher.walker.enable {
    self.programs.default.launcher = mkIf (prg.default.launcher.name == "walker") {
      dmenu = "walker --dmenu --"; # adding -- to prevent from flag incompatibilities
      drun = fastSocketCall;
      run = fastSocketCall; # no equivalent?, there is `>` prefix
    };

    hm.services.walker = {
      enable = true;
      systemd.enable = true;

      # https://github.com/abenz1267/walker/blob/master/resources/config.toml
      # ' exact search
      # ; providerlist
      # > runner
      # / files
      # . symbols
      # ! todo
      # % bookmarks
      # = calc
      # @ websearch
      # : clipboard
      # $ windows
      settings = {
        click_to_close = false;
        # hide_action_hints = true;
        keybind_symbols = false;
        ext_background_effect_blur = true;
      };

      theme.style = (/* css */ ''
        @define-color window_bg_color ${hexToRgba colors.background opacity.bg};
        @define-color accent_bg_color ${hexToRgba colors.comment opacity.bg};
        @define-color theme_fg_color ${hexToRgba colors.foreground opacity.fg};
        @define-color error_bg_color ${hexToRgba colors.red opacity.bg};
        @define-color error_fg_color ${hexToRgba colors.foreground opacity.fg};
      '')
      + (readFile ./style.css);
    };

    # this is 800MiB smh
    hm.services.elephant.enable = true;
  };
}
