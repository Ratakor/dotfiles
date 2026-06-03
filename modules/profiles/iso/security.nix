{
  security = {
    # Don't require sudo/root to `reboot` or `poweroff`.
    polkit.enable = true;

    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
}
