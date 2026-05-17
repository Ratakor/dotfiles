{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;

  package = pkgs.tor-browser;
in
{
  config = mkIf prg.browser.tor-browser.enable {
    # this should never be true tbh but I cba put a warning
    self.programs.default.browser = mkIf (prg.default.browser.name == "tor-browser") {
      inherit package;
      newWindow = "tor-browser --new-window";
    };

    user.packages = [ package ];
  };
}
