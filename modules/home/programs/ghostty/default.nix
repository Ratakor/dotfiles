{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
in
{
  config = mkIf prg.terminal.ghostty.enable {
    self.programs.default.terminal = mkIf (prg.default.terminal.name == "ghostty") {
      cmd = "ghostty";
      cmdDir = "${pkgs.writeShellScript "ghostty_cmdDir" ''
        ghostty --working-directory="$1"
      ''}";
    };

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
  };
}
