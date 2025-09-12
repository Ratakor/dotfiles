# TODO:
## game stuff, see lutris wiki & nix-gaming ig
#wine-staging
#winetricks
#lib32-alsa-plugins
#lib32-libpulse
#lib32-openal
#steam
##nvidia-dkms
#nvidia
#nvidia-utils
#multilib/lib32-nvidia-utils
#nvidia-settings
#opencl-nvidia
#giflib
#lib32-giflib
#libpng
#lib32-libpng
#libldap
#lib32-libldap
#gnutls
#lib32-gnutls
#mpg123
#lib32-mpg123
#openal
#lib32-openal
#v4l-utils
#lib32-v4l-utils
#libpulse
#lib32-libpulse
#libgpg-error
#lib32-libgpg-error
#alsa-plugins
#lib32-alsa-plugins
#alsa-lib
#lib32-alsa-lib
#libjpeg-turbo
#lib32-libjpeg-turbo
#sqlite
#lib32-sqlite
#libxcomposite
#lib32-libxcomposite
#libxinerama
#lib32-libgcrypt
#libgcrypt
#lib32-libxinerama
#ncurses
#lib32-ncurses
#ocl-icd
#lib32-ocl-icd
#libxslt
#lib32-libxslt
#libva
#lib32-libva
#gtk3
#lib32-gtk3
#gst-plugins-base-libs
#lib32-gst-plugins-base-libs
#vulkan-icd-loader
#lib32-vulkan-icd-loader
#xdg-desktop-portal-gtk
#lutris
{
  pkgs,
  self,
  ...
}: let
  terminal = with pkgs; [
    nbsdgames # 18 text-based modern games from bsd
    self.pkgs."2048-zig" # 2048 game in terminal
  ];

  star-citizen = with pkgs; [
    lug-helper # Script to manage and optimize Star Citizen on Linux
  ];

  wow = with pkgs; [
    wowup-cf # World of Warcraft addon updater with CurseForge support
    #warcraftlogsuploader # not in nixpkgs
    #raiderio-client # not in nixpkgs
  ];

  unsorted = with pkgs; [
    rili # Train Game
    love # lua 2D game engine (Balatro)
  ];
in [
  terminal
  # star-citizen
  # wow
  # unsorted
]
