# game stuff, see lutris wiki & nix-gaming ig
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton optional optionals;

  cfg = config.self.programs.gaming;

  terminal = with pkgs; [
    nbsdgames # 18 text-based modern games from bsd
    pkgs."2048-zig" # 2048 game in terminal, that naming messes with Nix
    binbreak # a terminal based binary number guessing game
  ];

  star-citizen = with pkgs; [
    lug-helper # Script to manage and optimize Star Citizen on Linux
  ];

  wow = with pkgs; [
    wowup-cf # World of Warcraft addon updater with CurseForge support
    #warcraftlogsuploader # not in nixpkgs
    #raiderio-client # not in nixpkgs
  ];

  poe = with pkgs; [
    rusty-path-of-building
    awakened-poe-trade
    exiled-exchange-2
  ];

  steam = singleton pkgs.steam;

  lutris = singleton pkgs.lutris;

  tools = with pkgs; [
    gamescope
    gamemode
    rivalcfg
  ];

  unsorted = with pkgs; [
    # rili # Train Game (removed from nixpkgs?)
    love # lua 2D game engine (Balatro)
  ];
in
[
  terminal
  tools
  # unsorted
]
++ optional cfg.star-citizen.enable star-citizen
++ optional cfg.wow.enable wow
++ optional cfg.poe.enable poe
++ optional cfg.steam.enable steam
++ optional cfg.lutris.enable lutris
|> optionals cfg.enable
