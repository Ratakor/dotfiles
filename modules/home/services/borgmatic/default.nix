# Backup tool
# TODO
{ pkgs, ... }:
{
  # install borgbackup (backup tool) too
  # python-llfuse # dependency for borg mount

  # borg wrapper
  hm.programs.borgmatic = {
    enable = false;
  };

  hm.services.borgmatic = {
    enable = false;
  };
}
