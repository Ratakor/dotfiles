{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir = ${config.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR}
    save_filename_format = swappy-%Y-%m-%d_%H:%M.png
    show_panel = true
  '';
}
