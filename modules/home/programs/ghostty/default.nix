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
  config = mkIf (config.self.terminal.program == "ghostty") {
    hm.programs.ghostty = {
      enable = true;
      systemd.enable = false; # TODO
      settings = {
        confirm-close-surface = false;
        window-decoration = "none";
        # gtk-titlebar = false;
        font-family = "monospace";
        font-size = config.self.fontSize;
        background-opacity = 0.8;
        theme = "Gruvbox Dark"; # TODO: use config.self.colors
        shell-integration-features = "no-cursor";
      };
      # I don't know what the below do
      # installVimSyntax = false;
      # installBatSyntax = false;
      # enableZshIntegration = false;
    };

    self.terminal = {
      cmd = "ghostty";
      cmdDir = "${pkgs.writeShellScript "ghostty_cmdDir" ''
        ghostty --working-directory="$1"
      ''}";
    };
  };
}
