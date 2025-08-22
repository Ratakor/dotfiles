{
  config,
  wallpapers,
  ...
}: {
  # TODO: maybe it's a bad idea to put wallpapers in inputs
  home.file."${config.xdg.userDirs.pictures}/wallpapers".source = wallpapers;
}
