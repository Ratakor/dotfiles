{ config, ... }:
let
  cfg = config.self.programs.apps.nixbit;
in
{
  programs.nixbit = {
    inherit (cfg) enable;
    repository = "https://github.com/ratakor/dotfiles";
  };
}
