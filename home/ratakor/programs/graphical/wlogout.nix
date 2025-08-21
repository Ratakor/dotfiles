# Wayland logout menu with wleave icons
# see https://github.com/ArtsyMacaw/wlogout/pull/59 for alternative icons
# requires glitchlock
{
  colors,
  pkgs,
  vega,
  ...
}: let
  inherit (vega.lib.trivial) hexToRgba;
in {
  programs.wlogout = {
    enable = true;
    # package = pkgs.wleave;
    layout = [
      {
        label = "lock";
        action = "glitchlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "logOut";
        keybind = "o";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "sUspend";
        keybind = "u";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    style = let
      iconsPath = "${pkgs.wleave}/share/wleave/icons";
      # iconsPath = "${pkgs.wlogout}/share/wlogout/assets";
    in ''
      * {
        background-image: none;
        box-shadow: none;
      }

      window {
        background-color: ${hexToRgba colors.background 0.85};
      }

      button {
        border-radius: 0;
        border-color: black;
        text-decoration-color: #${colors.foreground};
        color: #${colors.foreground};
        background-color: #${colors.background};
        border-style: solid;
        border-width: 1px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
      }

      button:focus, button:active, button:hover {
        background-color: #${colors.red};
        outline-style: none;
      }

      #lock,
      #logout,
      #suspend,
      #hibernate,
      #shutdown,
      #reboot {
        background-size: 40%;
      }

      #lock {
        background-image: image(url("${iconsPath}/lock.svg"));
      }

      #logout {
        background-image: image(url("${iconsPath}/logout.svg"));
      }

      #suspend {
        background-image: image(url("${iconsPath}/suspend.svg"));
      }

      #hibernate {
        background-image: image(url("${iconsPath}/hibernate.svg"));
      }

      #shutdown {
        background-image: image(url("${iconsPath}/shutdown.svg"));
      }

      #reboot {
        background-image: image(url("${iconsPath}/reboot.svg"));
      }
    '';
  };
}
