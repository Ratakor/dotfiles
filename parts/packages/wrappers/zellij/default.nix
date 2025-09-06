# Terminal multiplexer & session manager
{pkgs, ...}: {
  wrappers.zellij = {
    basePackage = pkgs.zellij; # TODO: patch for zsh completions
    prependFlags = ["--config" ./config.kdl];
  };
}
