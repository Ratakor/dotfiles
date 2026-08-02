# Mirror of __module.nix to be used outside of modules.
{
  theme ? "gruvbox", # gruvbox dracula eldritch evangelion
  variant ? "dark", # dark light
}:
let
  self = {
    inherit theme variant;
    dark = import ./themes/${theme}/dark.nix;
    light = import ./themes/${theme}/light.nix;
    default = self.${variant};
  };
in
self
