{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  colors = config.self.colors.default;
  prg = config.self.programs;
  dprg = prg.default;
  isDefault = dprg.terminal.name == "ghostty";
in
{
  config = mkIf prg.terminal.ghostty.enable {
    self.programs.default.terminal = mkIf isDefault {
      cmd = "ghostty";
      cmdDir = "${pkgs.writeShellScript "ghostty_cmdDir" ''
        ghostty --working-directory="$1"
      ''}";
    };

    hm.programs.ghostty = {
      enable = true;
      systemd.enable = isDefault;
      enableZshIntegration = true;
      settings = {
        confirm-close-surface = false;
        window-decoration = "none";
        # gtk-titlebar = false;
        font-family = "monospace";
        font-size = prg.terminal.fontSize;
        background-opacity = 0.8;
        theme =
          if dprg.desktopShell.name == "noctalia" then
            "noctalia"
          else if dprg.desktopShell.name == "dms" then
            "dankcolors"
          else
            "nix"; # defined below
        shell-integration-features = "no-cursor";
        window-inherit-working-directory = false;
        # this is supposed to fix memory issues but I think it's enblaed by
        # default on linux anyway and it doesn't seem to work well too
        gtk-single-instance = true;
        keybind = [
          "ctrl+shift+plus=increase_font_size:1"
          "ctrl+shift+minus=decrease_font_size:1"
          "ctrl+equal=reset_font_size"
        ];
      };
      themes.nix = {
        background = colors.background;
        foreground = colors.foreground;
        cursor-color = colors.foreground;
        # cursor-text = colors.background;
        selection-foreground = colors.foreground;
        selection-background = colors.selection;
        palette = [
          "0=${colors.black}"
          "1=${colors.red}"
          "2=${colors.green}"
          "3=${colors.yellow}"
          "4=${colors.blue}"
          "5=${colors.magenta}"
          "6=${colors.cyan}"
          "7=${colors.white}"
          "8=${colors.bright.black}"
          "9=${colors.bright.red}"
          "10=${colors.bright.green}"
          "11=${colors.bright.yellow}"
          "12=${colors.bright.blue}"
          "13=${colors.bright.magenta}"
          "14=${colors.bright.cyan}"
          "15=${colors.bright.white}"
        ];
      };
    };
  };
}
