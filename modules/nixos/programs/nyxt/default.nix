# browser for lisp people
# TODO: incomplete
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;

  package = pkgs.nyxt;
in
{
  config = mkIf prg.browser.nyxt.enable {
    self.programs.default.browser = mkIf (prg.default.browser.name == "nyxt") {
      inherit package;
      newWindow = "nyxt"; # smh --new-window doesn't exist
    };

    user.packages = [ package ];
  };
}
