{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Spell Checker
    hunspell
    hunspellDicts.en-us
    hunspellDicts.fr-moderne

    # not an emulator btw (also wayland support is experimental)
    wineWow64Packages.waylandFull
  ];
}
