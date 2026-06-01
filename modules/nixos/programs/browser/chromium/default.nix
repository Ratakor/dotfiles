{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) listToAttrs;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.meta) getExe;

  prg = config.self.programs;
  cfg = prg.browser.chromium;

  configDir = if cfg.package.pname == "helium" then "net.imput.helium" else "chromium";
in
{
  config = mkIf cfg.enable {
    self.programs.default.browser = mkIf (prg.default.browser.name == "chromium") {
      inherit (cfg) package;
      newWindow = "${getExe cfg.package} --new-window";
    };

    user.packages = [ cfg.package ];

    # based on https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix
    hj.xdg.config.files = mkMerge [
      (listToAttrs (
        map (dict: {
          name = "${configDir}/Dictionaries/${dict.passthru.dictFileName}";
          value.source = dict;
        }) cfg.dictionaries
      ))
      (listToAttrs (
        map (ext: {
          name = "${configDir}/External Extensions/${ext}.json";
          value.text = ''
            {"external_update_url":"https://clients2.google.com/service/update2/crx"}
          '';
        }) cfg.extensions
      ))
      (mkIf cfg.drm.enable {
        # https://github.com/imputnet/helium/issues/116#issuecomment-3668370766
        "${configDir}/WidevineCdm/latest-component-updated-widevine-cdm".text = ''
          {"Path":"${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm"}
        '';
      })
    ];

    # cool (but unused) patches: https://github.com/noahvogt/chromium-patches

    # TODO: commandLineArgs
    # See some hardening args here
    # https://github.com/Ratakor/dotfiles/blob/artix/.local/bin/browser
    # See celenityy/Titanium too
    # UC Flags needs to be configured for it to be as good as cromite
  };
}
