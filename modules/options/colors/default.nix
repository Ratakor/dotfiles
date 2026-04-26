# Mirror of module.nix to be used outside of modules.
{
  lib,
  pkgs,
  theme ? "gruvbox", # gruvbox dracula
  variant ? "dark", # dark light
}:
lib.fix (self: {
  dark = import ./themes/${theme}-dark.nix pkgs;
  light = import ./themes/${theme}-light.nix pkgs;
  default = self.${variant};
  alternative = self.${if variant == "dark" then "light" else "dark"};
})
