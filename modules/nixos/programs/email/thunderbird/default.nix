{
  config,
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) optional;

  prg = config.self.programs;
  cfg = prg.email.thunderbird;

  package = pkgs.thunderbird;
in
{
  imports = [ sources.dove.nixosModules.default ];

  config = {
    self.programs.default.email = mkIf (prg.default.email.name == "thunderbird") {
      inherit package;
    };

    user.packages = optional cfg.enable package;

    programs.thunderbird.dove.enable = cfg.dove;
  };
}
