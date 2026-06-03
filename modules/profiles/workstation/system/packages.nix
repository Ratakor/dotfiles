{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Spell Checker
    hunspell
    hunspellDicts.en-us
    hunspellDicts.fr-moderne

    # not an emulator btw
    # wineWow64Packages.waylandFull # unstable (doesn't work)
    wineWow64Packages.stableFull
  ];
}
