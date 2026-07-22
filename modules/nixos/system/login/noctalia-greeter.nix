{
  config,
  lib,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf;

  colors = config.self.colors.default;
  dprg = config.self.programs.default;
  sys = config.self.system;
in
{
  imports = [ sources.noctalia-greeter.nixosModules.default ];

  programs.noctalia-greeter = mkIf (sys.login.manager == "noctalia-greeter") {
    enable = true;
    settings = {
      # session.default = dprg.windowManager.name;

      user.default = config.user.name;

      # make it based on config.self.device.monitors?
      # output = {
      #   scale = 2.0;
      # };

      idle.timeout = 300;

      cursor = {
        inherit (colors.cursor) theme;
        # 24 looks goofy, let's keep default (which is probably 24 anyway)
        # size = 24; # same as niri, there should be an option for that
      };

      keyboard = {
        inherit (sys.keyboard) layout variant options;
        # numlock = false;
      };

      appearance = {
        scheme = colors.noctalia.theme;
        hide_logo = true; # idk if I want it tbh, it kinda looks good
      };

      auth.allow_empty_password = true; # needed by fprintd
    };
  };
}
