# Handle multiple displays gracefully
{ config, ... }:
{
  # see wlr-randr too
  # TODO: add exec option to profiles to move workspace to the right output
  # TODO: add config.self.services.kanshi.enable
  # TODO: add config.self.services.kanshi.settings
  hm.services.kanshi = {
    enable = config.self.system.displayServer == "wayland";
    settings = [
      {
        profile = {
          name = "undocked";
          outputs = [
            {
              criteria = "LVDS-1";
              status = "enable";
            }
          ];
        };
      }
      {
        profile = {
          name = "docked";
          outputs = [
            {
              criteria = "LVDS-1";
              status = "disable";
            }
            {
              criteria = "Microstep MSI MPG27CQ2 0x30304E37";
              # mode = "1920x1080@60";
              scale = 1.5;
            }
          ];
        };
      }
    ];
  };
}
