{
  programs.imv = {
    enable = true;
    # package = # TODO: use git version: v4.5.0 doesn't work with gifs
    settings.binds = {
      n = "next";
      p = "prev";
      "<Ctrl+p>" = "exec echo $imv_current_file";
    };
  };
}
