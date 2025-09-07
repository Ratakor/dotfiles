# TODO: config dmenu, fuzzel, tofi
{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) str nullOr;
in {
  options.self = {
    menu = {
      dynamic = mkOption {
        type = nullOr str;
        default = null;
        description = "A dynamic menu like dmenu.";
      };
      drun = mkOption {
        type = nullOr str;
        default = null;
        description = "A dynamic menu to use for launching applications from desktop files.";
      };
      run = mkOption {
        type = nullOr str;
        default = null;
        description = "A dynamic menu to use for launching applications from $PATH.";
      };
    };
  };
}
