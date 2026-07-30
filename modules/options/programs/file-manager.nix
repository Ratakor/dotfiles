{ config, lib, ... }:
let
  inherit (lib.options) mkProgram mkOption literalExpression;
  inherit (lib.types) str;
in
mkProgram config "file manager" {
  values = [
    "yazi" # terminal file manager
    "nautilus" # gnome
    "dolphin" # kde
  ];
  redirectTo = "xdg.portal";
  default =
    if config.self.programs.default.xdg.portal.name == "gnome" then
      "nautilus"
    else if config.self.programs.default.xdg.portal.name == "kde" then
      "dolphin"
    else
      "yazi";
  defaultText = literalExpression ''
    if config.self.programs.default.xdg.portal.name == "gnome" then
      "nautilus"
    else if config.self.programs.default.xdg.portal.name == "kde" then
      "dolphin"
    else
      "yazi"
  '';
  extraOptions = {
    yazi.enable.default = true;
  };
  extraDefaultOptions = {
    desktopEntry = mkOption {
      type = str;
      description = "The desktop entry of the default file manager.";
      internal = true;
    };
  };
}
