# The application panicked (crashed).
# Message:  Failed to create vertices shader:
#    0: 0:2(10): error: GLSL ES 3.10 is not supported. Supported versions are: 1.00 ES
{ config, self, ... }:
let
  inherit (self.pins) wallpapers;
in
{
  hm.services.wpaperd = {
    enable = false; # config.self.displayServer == "wayland";

    settings = {
      default = {
        path = "${wallpapers}";
        duration = "30m";
        sorting = "random";
        mode = "center";
        # transition-time = 0; # default: 300
        # queue-size = 4; # default: 10
        # initial-transition = false; # default: true
        recursive = true;
      };
    };
  };
}
