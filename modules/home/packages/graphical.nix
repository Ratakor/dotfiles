{
  pkgs,
  self,
  ...
}: let
  wayland = {
    unsorted = with pkgs; [
      grim # screenshot
      slurp # region selection
      # swayppy # image editor for screenshots
      wl-clipboard # clipboard management
      wf-recorder # screen recording
      swaybg # wallpaper utility
      wlopm # power management (black screen)
      swaylock # screen locker
    ];
  };
in [
  wayland.unsorted
]
