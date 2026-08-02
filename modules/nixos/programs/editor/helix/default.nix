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
      inherit package; # this should be fine even when not actually using the wrapper
    };

    # user.packages = [ package ];

    # we can't use the wrapper if we want to be able to use the noctalia theme
    # which is actually pretty decent when derived from wallpaper
    hm.programs.helix = {
      enable = true;
      extraPackages = map (x: x.data) package.configuration.runtimePkgs;
      settings =
        package.configuration.settings
        // (optionalAttrs prg.desktopShell.noctalia.enable { theme = "noctalia"; });
      inherit (package.configuration) languages themes;
    };

    # if using steelix, I'm not even sure this works since we're using a wrapper
    # hm.xdg.configFile."helix/runtime".source = pkgs.steelix.src + /runtime;
  };
}
