{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption literalExpression;

  mkEnableOption' =
    desc:
    mkEnableOption desc
    // {
      default = sys.video.enable;
      defaultText = literalExpression ''
        sys.video.enable;
      '';
    };

  sys = config.self.system;
in
{
  options.self.services = {
    wpaperd.enable = mkEnableOption' "wpaperd, Wallpaper daemon";
    mako.enable = mkEnableOption' "mako, Notification daemon";
    gammastep.enable = mkEnableOption' "gammastep, Screen color temperature manager";

    swayidle.enable = mkEnableOption "swayidle, Idle manager";
    kanshi.enable = mkEnableOption "Kanshi, Dynamic display configuration tool";
  };
}
