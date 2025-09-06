# Terminal multiplexer & session manager
{
  wrap.programs.zellij = {
    enable = true;
    # package = # TODO: patch for zsh completions
    config = ./config.kdl;
  };
}
