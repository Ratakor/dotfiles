{
  config,
  lib,
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
        font-familiy = "monospace";
        font-size = 16;
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
      cmdDir = "ghostty --working-directory";
    };
  };
}
