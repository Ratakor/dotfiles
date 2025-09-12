{ config, ... }:
{
  console.colors = with config.self.colors; [
    black
    red
    green
    yellow
    blue
    magenta
    cyan
    white
    bright_black
    bright_red
    bright_green
    bright_yellow
    bright_blue
    bright_magenta
    bright_cyan
    bright_white
  ];
}
