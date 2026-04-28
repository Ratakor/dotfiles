{
  services.dbus.implementation = "broker";

  systemd.settings.Manager = {
    # Timeout 90s -> 10s to avoid hanging the system on boot or shutdown
    DefaultTimeoutStartSec = "10s";
    DefaultTimeoutStopSec = "10s";
    DefaultTimeoutAbortSec = "10s";
    DefaultDeviceTimeoutSec = "10s";
  };
}
