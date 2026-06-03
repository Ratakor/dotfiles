{
  systemd = {
    enableEmergencyMode = false;
    sleep.settings.Sleep = {
      AllowSuspend = "no";
      AllowHibernation = "no";
    };
  };
}
