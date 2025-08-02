{
  config,
  ...
}: {
  # TODO: this shouldn't be like that as it prevents from writing in ~/.local/bin
  # also I dislike RO configs
  home.file."${config.home.homeDirectory}/.local/bin" = {
      source = ./bin;
      recursive = true;
      executable = true;
  };
}
