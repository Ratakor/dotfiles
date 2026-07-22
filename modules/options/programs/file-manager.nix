{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.options) mkOption mkEnableOptions literalExpression;
  inherit (lib.types) enum str;

  odprg = options.self.programs.default;
  dprg = config.self.programs.default;
in
{
  options.self.programs = {
    fileManager = recursiveUpdate (mkEnableOptions odprg.fileManager.name) {
      yazi.enable.default = true;
    };

    default.fileManager = {
      name = mkOption {
        type = enum [
          "yazi" # terminal file manager
          "nautilus" # gnome
          "dolphin" # kde
        ];
        default =
          if dprg.xdg.portal.name == "gnome" then
            "nautilus"
          else if dprg.xdg.portal.name == "kde" then
            "dolphin"
          else
            "yazi";
        defaultText = literalExpression ''
          if dprg.xdg.portal.name == "gnome" then
            "nautilus"
          else if dprg.xdg.portal.name == "kde" then
            "dolphin"
          else
            "yazi"
        '';
        description = ''
          The default file manager to use.
          This will automatically enable the corresponding program.
          Consider setting config.self.programs.default.xdg.portal.name instead.
        '';
      };

      desktopEntry = mkOption {
        type = str;
        description = "The desktop entry of the default file manager.";
        internal = true;
      };
    };
  };

  config.self.programs = {
    fileManager.${dprg.fileManager.name}.enable = true;
  };
}
