# Terminal multiplexer & session manager
{
  programs.zellij = {
    enable = true;
    # package = # TODO: patch for zsh completions
    config = ./config.kdl;
  };
}
