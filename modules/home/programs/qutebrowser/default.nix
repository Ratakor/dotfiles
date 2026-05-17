# "minimal" vim-like browser
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

  package = pkgs.qutebrowser;
in
{
  config = mkIf prg.browser.qutebrowser.enable {
    self.programs.default.browser = mkIf (prg.default.browser.name == "qutebrowser") {
      inherit package;
      newWindow = "qutebrowser"; # opens a new window by default
    };

    user.packages = [ package ];
  };
}
