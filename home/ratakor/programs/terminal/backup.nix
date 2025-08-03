{
  pkgs,
  ...
}: {
  # TODO
  # install borgbackup (backup tool) too

  # borg wrapper
  programs.borgmatic = {
    enable = true;
  };

  services.borgmatic = {
    enable = true;
  };
}
