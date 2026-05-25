{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  package = pkgs.wrappers.helix.override {
    inherit (config.self.colors.default.helix) theme;
  };

  prg = config.self.programs;
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
