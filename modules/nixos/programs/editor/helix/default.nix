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
  dprg = prg.default;
  cfg = prg.editor.helix;

  package = pkgs.wrappers.helix.override (
    {
      inherit (config.self) colors; # used for helix theme
    }
    // (optionalAttrs (!prg.dev.enable) { extraPackages = [ ]; })
  );
in
{
  config = mkIf cfg.enable {
    self.programs.default.editor = mkIf (dprg.editor.name == "helix") {
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
        // (optionalAttrs cfg.enableNoctaliaIntegration { theme = "noctalia"; });
      inherit (package.configuration) languages themes;
    };

    # if using steelix, I'm not even sure this works since we're using a wrapper
    # hm.xdg.configFile."helix/runtime".source = pkgs.steelix.src + /runtime;
  };
}
