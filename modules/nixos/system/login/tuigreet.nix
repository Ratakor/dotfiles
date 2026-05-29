{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) concatStringsSep;
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe;

  cfg = config.self.system.login;
in
{
  services.greetd = mkIf (cfg.manager == "tuigreet") {
    enable = true;
    useTextGreeter = true;
    settings.default_session = {
      command = concatStringsSep " " [
        (getExe pkgs.tuigreet)
        "--time"
        "--asterisks"
        "--remember"
        # "--remember-user-session" # I'm pretty sure this doesn't work
        "--remember-session"
        # "--cmd 'zsh'"
      ];
      user = "greeter";
    };
  };
}
