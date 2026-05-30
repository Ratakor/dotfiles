{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Spell Checker
    hunspell
    hunspellDicts.en-us
    hunspellDicts.fr-moderne
  ];
}
