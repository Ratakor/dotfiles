{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf (config.self.programs.terminal.program == "ghostty") {
    hm.programs.ghostty = {
      enable = true;
      systemd.enable = true;
      settings = {
        confirm-close-surface = false;
        window-decoration = "none";
        # gtk-titlebar = false;
        font-family = "monospace";
        font-size = config.self.fontSize;
        background-opacity = 0.8;
        inherit (config.self.colors.default.ghostty) theme;
        shell-integration-features = "no-cursor";
        window-inherit-working-directory = false;
      };
      enableZshIntegration = true;
    };

    self.programs.terminal = {
      cmd = "ghostty";
      cmdDir = "${pkgs.writeShellScript "ghostty_cmdDir" ''
        ghostty --working-directory="$1"
      ''}";
    };
  };
}
