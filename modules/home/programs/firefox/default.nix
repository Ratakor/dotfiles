# TODO: incomplete
{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
  cfg = prg.browser.firefox;
in
{
  config = mkIf cfg.enable {
    self.programs.default.browser = mkIf (prg.default.browser.name == "firefox") {
      inherit (cfg) package;
      newWindow = "firefox --new-window";
    };

    user.packages = [ cfg.package ];
  };
}
