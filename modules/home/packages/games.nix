# TODO: make this more configurable host wise
# game stuff, see lutris wiki & nix-gaming ig
{
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib.lists) singleton;

  terminal = with pkgs; [
    nbsdgames # 18 text-based modern games from bsd
    self.pkgs."2048-zig" # 2048 game in terminal
    self.pkgs.binbreak # a terminal based binary number guessing game
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
    self.pkgs.exiled-exchange-2
  ];

  steam = singleton pkgs.steam;

  lutris = singleton pkgs.lutris;

  tools = with pkgs; [
    gamescope
    rivalcfg
  ];

  unsorted = with pkgs; [
    rili # Train Game
    love # lua 2D game engine (Balatro)
  ];
in
[
  terminal
  steam
  # lutris
  tools
  poe
  # star-citizen
  # wow
  # unsorted
]
