{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  inherit (config.self) user;
  dprg = config.self.programs.default;
  cfg = config.self.system.login;
in
{
  services = mkIf cfg.autoLogin {
    getty = mkIf (cfg.manager == null) {
      autologinOnce = true; # ?
      autologinUser = user.name;
    };

    greetd.settings.initial_session = {
      command = dprg.windowManager.cmd;
      user = user.name;
    };

    displayManager = {
      # only work with gdm, sddm and lightdm iirc
      defaultSession = dprg.windowManager.session;
      autoLogin = {
        enable = true;
        user = user.name;
      };
    };
  };
}
