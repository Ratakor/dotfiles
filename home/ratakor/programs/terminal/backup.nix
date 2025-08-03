# TODO

{
  pkgs,
  ...
}: {
  # install borgbackup (backup tool) too

  # borg wrapper
  programs.borgmatic = {
    enable = false;
  };

  services.borgmatic = {
    enable = false;
  };
}
