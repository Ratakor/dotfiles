# Notification daemon
{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  colors = config.self.colors.default;
  cfg = config.self.programs.notification.mako;
in
{
  # let's assume that if cfg.enable is true that means mako is the default notification daemon
  config = mkIf cfg.enable {
    hm.services.mako = {
      enable = true;
      settings = {
        width = 350;
        height = 400;
        border-size = 2;
        default-timeout = 5000;
        font = "monospace";
        max-icon-size = 32;
        #on-button-middle=exec makoctl menu -n "$id" "$MENU" -p "Select action:"

        # e6 is 0.9 alpha btw
        background-color = "#${colors.background}e6";
        text-color = "#${colors.foreground}ff";
        border-color = "#${colors.blue}ff";
      };
      extraConfig = ''
        [urgency=low]
        border-color=#${colors.green}ff

        [urgency=high]
        border-color=#${colors.red}ff
        default-timeout=0
      '';
    };
  };
}
