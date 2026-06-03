# Mirror of __module.nix to be used outside of modules.
{
  theme ? "gruvbox", # gruvbox dracula
  variant ? "dark", # dark light
}:
let
  self = {
    inherit theme variant;
    dark = import ./themes/${theme}-dark.nix;
    light = import ./themes/${theme}-light.nix;
  };
in
self
// {
  default = self.${variant};
  alternative = self.${if variant == "dark" then "light" else "dark"};
}
