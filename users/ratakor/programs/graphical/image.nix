{
  programs.imv = {
    enable = true;
    settings.binds = {
      n = "next";
      p = "prev";
      "<Ctrl+p>" = "exec echo $imv_current_file";
    };
  };
}
