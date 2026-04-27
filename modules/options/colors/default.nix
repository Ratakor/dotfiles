# Mirror of module.nix to be used outside of modules.
{
  lib,
  theme ? "gruvbox", # gruvbox dracula
  variant ? "dark", # dark light
}:
lib.fix (self: {
  dark = import ./themes/${theme}-dark.nix;
  light = import ./themes/${theme}-light.nix;
  default = self.${variant};
  alternative = self.${if variant == "dark" then "light" else "dark"};
})
