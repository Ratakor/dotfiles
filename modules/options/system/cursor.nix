{ config, lib, ... }:
let
  inherit (lib.options) mkOption literalExpression;
  inherit (lib.strings) toSentenceCase;
  inherit (lib.types) int str;
in
{
  options.self.system.cursor = {
    theme = mkOption {
      type = str;
      default = "Simp1e-${toSentenceCase config.self.colors.variant}";
      defaultText = literalExpression ''
        Simp1e-''${lib.strings.toSentenceCase config.self.colors.variant}
      '';
      description = "Cursor theme.";
    };

    size = mkOption {
      type = int;
      default = 24;
      description = "Cursor size.";
    };
  };
}
