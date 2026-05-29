# Handle multiple displays gracefully
{ config, ... }:
{
  # see wlr-randr too
  # TODO: add exec option to profiles to move workspace to the right output
  # TODO: add config.self.services.kanshi.settings
  hm.services.kanshi = {
    inherit (config.self.services.kanshi) enable;
    # This is the config for X200
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
