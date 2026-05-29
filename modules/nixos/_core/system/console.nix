{ config, ... }:
{
  console.colors = with config.self.colors.default; [
    black
    red
    green
    yellow
    blue
    magenta
    cyan
    white
    bright.black
    bright.red
    bright.green
    bright.yellow
    bright.blue
    bright.magenta
    bright.cyan
    bright.white
  ];
}
