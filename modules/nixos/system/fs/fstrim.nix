{
  # Keeping default values.
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Make fstrim nice to other processes to save power and avoid
  # locking down the system in an unexpected manner.
  # From notashelf/nyx/modules/core/common/system/os/fs/module.nix
  systemd.services.fstrim = {
    unitConfig.ConditionACPower = true;
    serviceConfig = {
      Nice = 19; # lowest priority (idk actually)
      IOSchedulingClass = "idle";
    };
  };
}
