{ pkgs, ... }:
{
  hm.programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
  };
  # TODO: look at taskwarrior-sync
}
