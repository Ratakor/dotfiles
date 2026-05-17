# TODO: incomplete
# check out celenityy/phoenix...
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;

  package = pkgs.firefox;
in
{
  config = mkIf prg.browser.firefox.enable {
    self.programs.default.browser = mkIf (prg.default.browser.name == "firefox") {
      inherit package;
      newWindow = "firefox --new-window";
    };

    user.packages = [ package ];
  };
}
