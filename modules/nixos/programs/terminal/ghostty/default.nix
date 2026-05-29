{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
  isDefault = prg.default.terminal.name == "ghostty";
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
      settings = {
        confirm-close-surface = false;
        window-decoration = "none";
        # gtk-titlebar = false;
        font-family = "monospace";
        font-size = prg.terminal.fontSize;
        background-opacity = 0.8;
        inherit (config.self.colors.default.ghostty) theme;
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
      enableZshIntegration = true;
    };
  };
}
