{ config, lib, ... }:
let
  inherit (lib.options) mkVideoProgram literalExpression;
in
mkVideoProgram config "XDG Portal" {
  values = [
    "gnome"
    "gtk"
    "kde"
  ];
  optionPath = [
    "xdg"
    "portal"
  ];
  default = "gnome";
  extraOptions = {
    # gtk is used as fallback
    gtk.enable = {
      default = config.self.system.video.enable;
      defaultText = literalExpression ''
        config.self.system.video.enable
      '';
    };
  };
}
