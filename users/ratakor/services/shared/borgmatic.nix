# TODO
{pkgs, ...}: {
  # install borgbackup (backup tool) too
  # python-llfuse # dependency for borg mount

  # borg wrapper
  programs.borgmatic = {
    enable = false;
  };

  services.borgmatic = {
    enable = false;
  };
}
