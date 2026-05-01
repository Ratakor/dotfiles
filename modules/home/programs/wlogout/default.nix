# Wayland logout menu with wleave icons
# Alternative icons: https://github.com/ArtsyMacaw/wlogout/pull/59
# X11 alternative (kinda): https://github.com/Ratakor/dotfiles/blob/artix/.local/bin/shutdown-menu
# TODO: switch to wleave
# - Config layout without nix & style with a fin layer since it's css.
# - Currently only issue is that gtk4 seems bugged with this nixos config
#   that's why I'm still using wlogout.
# ---
# I switched to dms powermenu
{
  config,
  lib,
  pkgs,
  ...
}:
let
  colors = config.self.colors.default;
  dprg = config.self.programs.default;
in
{
  config = lib.mkIf false {
    programs.gdk-pixbuf.modulePackages = with pkgs; [
      librsvg # add svg support to gdk-pixbuf (wlogout)
    ];

    hm.programs.wlogout = {
      enable = true;
      # package = pkgs.wleave;

      # l s p
      # e h r
      layout = [
        {
          label = "lock";
          action = "${dprg.locker.cmd}";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "logout";
          action = "loginctl terminate-user $USER";
          text = "Exit";
          keybind = "e";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "s";
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
          text = "Poweroff";
          keybind = "p";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
      style =
        let
          iconsPath = "${pkgs.wleave}/share/wleave/icons";
          # iconsPath = "${pkgs.wlogout}/share/wlogout/assets";
        in
        # css
        ''
          * {
            background-image: none;
            box-shadow: none;
          }

          window {
            background-color: ${lib.hexToRgba colors.background 0.85};
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
  };
}
