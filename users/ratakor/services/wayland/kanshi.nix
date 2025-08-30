# Handle multiple displays gracefully
{
  # see wlr-randr
  # TODO: add exec option to profiles to move workspace to the right output
  services.kanshi = {
    enable = true;
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
