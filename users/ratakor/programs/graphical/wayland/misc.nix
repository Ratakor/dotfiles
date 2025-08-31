{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    grim # screenshot
    slurp # region selection
    # swayppy # image editor for screenshots
    wl-clipboard # clipboard management
    wf-recorder # screen recording
    swaybg # wallpaper utility
    wlopm # power management (black screen)
  ];

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir = ${config.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR}
    save_filename_format = swappy-%Y-%m-%d_%H:%M.png
    show_panel = true
  '';
}
