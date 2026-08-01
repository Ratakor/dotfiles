{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.modules) mkIf;

  prg = config.self.programs;

  package = pkgs.wrappers.helix.override (
    {
      inherit (config.self) colors; # used for helix theme
    }
    // (optionalAttrs (!prg.dev.enable) { extraPackages = [ ]; })
  );
in
{
  config = mkIf prg.editor.helix.enable {
    self.programs.default.editor = mkIf (prg.default.editor.name == "helix") {
      inherit package;
    };

    user.packages = [ package ];

    # if using steelix, I'm not even sure this works since we're using a wrapper
    # hm.xdg.configFile."helix/runtime".source = pkgs.steelix.src + /runtime;
  };
}
