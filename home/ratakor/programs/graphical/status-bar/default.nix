{
  colors,
  lib,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings.mainBar = {
      layer = "top";
      spacing = 0;

      modules-left = [
        "river/tags"
        "niri/workspaces"
      ];
      modules-center = [
        # "river/window"
        # "niri/window"
        # "image"
        "custom/spotify"
        "custom/music"
      ];
      modules-right = [
        "temperature"
        "battery"
        "network"
        "bluetooth"
        "wireplumber"
        "custom/weather"
        "clock"
      ];
      "river/window" = {
        max-length = 50;
        tooltip = false;
      };
      image = {
        path = "/tmp/cover.jpg";
        # TODO
      };
      "custom/spotify" = {
        exec = "zpotify waybar";
        return-type = "json";
        tooltip = true;
        on-click = "zpotify pause >/dev/null";
        max-length = 40;
      };
      "custom/music" = {
        exec = pkgs.writeShellScript "waybar-music" (builtins.readFile ./scripts/music.sh);
        interval = "once";
        signal = 1;
        max-length = 40;
        tooltip = false;
        on-click = "musiccmd";
      };
      temperature = {
        format = " {temperatureC}°C";
        format-critical = " {temperatureC}°C";
        critical-threshold = 80;
        tooltip = false;
        on-click = "$TERMINAL -e htop";
      };
      battery = {
        full-at = 99;
        format = "{icon} {capacity}%";
        format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        states = {
          "100" = 100;
          "90" = 90;
          "80" = 80;
          "70" = 70;
          "60" = 60;
          "50" = 50;
          "40" = 40;
          "30" = 30;
          "20" = 20;
          "10" = 10;
          "0" = 0;
        };
        format-charging-100 = "󰂅 {capacity}%";
        format-charging-90 = "󰂋 {capacity}%";
        format-charging-80 = "󰂊 {capacity}%";
        format-charging-70 = "󰢞 {capacity}%";
        format-charging-60 = "󰂉 {capacity}%";
        format-charging-50 = "󰢝 {capacity}%";
        format-charging-40 = "󰂈 {capacity}%";
        format-charging-30 = "󰂇 {capacity}%";
        format-charging-20 = "󰂆 {capacity}%";
        format-charging-10 = "󰢜 {capacity}%";
        format-charging-0 = "󰢟 {capacity}%";
        tooltip = true;
      };
      network = {
        interface = "wlp2s0";
        format-wifi = "{icon} {essid}";
        format-disconnected = "󰤯";
        tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        format-icons = ["󰤟" "󰤢" "󰤨"];
        tooltip = true;
        on-click = "$TERMINAL -e nmtui";
      };
      bluetooth = {
        format-disabled = "";
        format-connected = " {device_alias}";
        tooltip-format = "{controller_alias}\t{controller_address}";
        tooltip-format-connected = "{controller_alias}\t\t{controller_address}\n{device_alias}\t{device_address}";
        on-click = "$TERMINAL -e bluetoothctl";
      };
      wireplumber = {
        format = "{icon} {volume}%";
        format-icons = ["" "" ""];
        tooltip = false;
        max-volume = 150;
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      "custom/weather" = {
        exec = pkgs.writeShellScript "waybar-weather" (builtins.readFile ./scripts/weather.sh);
        return-type = "json";
        format = "{}";
        max-length = 10;
        interval = 3600;
        tooltip = true;
      };
      clock = {
        format = " {:%H:%M}";
        format-alt = " {:%b %d (%a)}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          format = {
            today = "<b><u>{}</u></b>";
          };
        };
      };
    };

    style = let
      inherit (lib.trivial) fromHexString;
      inherit (builtins) substring;

      r = toString (fromHexString (substring 0 2 colors.background));
      g = toString (fromHexString (substring 2 2 colors.background));
      b = toString (fromHexString (substring 4 2 colors.background));
      background = "rgba(${r}, ${g}, ${b}, 0.85)";
    in ''
      @define-color foreground #${colors.foreground};
      @define-color background ${background};

      @define-color black   #${colors.black};
      @define-color red     #${colors.red};
      @define-color green   #${colors.green};
      @define-color yellow  #${colors.yellow};
      @define-color blue    #${colors.blue};
      @define-color magenta #${colors.magenta};
      @define-color cyan    #${colors.cyan};
      @define-color white   #${colors.white};
      @define-color orange  #${colors.orange};

      @define-color bright_black   #${colors.bright_black};
      @define-color bright_red     #${colors.bright_red};
      @define-color bright_green   #${colors.bright_green};
      @define-color bright_yellow  #${colors.bright_yellow};
      @define-color bright_blue    #${colors.bright_blue};
      @define-color bright_magenta #${colors.bright_magenta};
      @define-color bright_cyan    #${colors.bright_cyan};
      @define-color bright_white   #${colors.bright_white};
      @define-color bright_orange  #${colors.bright_orange};

      * {
          padding: 0;
          margin: 0;
          font-family: monospace;
          /* font-size: 14px; */
      }

      window#waybar {
          background: @background;
          color: @foreground;
      }

      #window,
      #tags,
      #workspaces,
      #custom-spotify,
      #custom-music,
      #temperature,
      #bluetooth,
      #battery,
      #network,
      #wireplumber,
      #custom-weather,
      #clock {
          padding-left: 5px;
          padding-right: 5px;
          padding-top: 0px;
          padding-bottom: 0px;
      }

      #tags, #workspaces {
          padding-left: 0px;
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      #tags button:hover, #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
          background: @bright_black;
      }

      #tags button, #workspaces button {
          /* Disable animation on click */
          transition-property: none;

          font-size: 0;
          min-width: 16px;
          min-height: 16px;
          margin: 3px;
          margin-top: 3px;
          margin-bottom: 3px;
          border-radius: 30px;
          border: 2px solid @bright_black;
          background-color: @bright_black;
          /* transition: 100ms; */
      }

      #tags button.focused, #workspaces button.active {
          min-width: 28px;
          border: 2px solid @blue;
          background: @blue;
          /* transition: 100ms; */
      }

      #tags button.occupied, #workspaces button:not(.empty) {
          border: 2px solid @foreground;
      }

      #tags button.urgent {
          border: 2px solid @red;
      }

      #image, #custom-spotify, #custom-music {
          border-bottom: 2px solid @green;
      }

      #temperature {
          border-bottom: 2px solid @cyan;
      }

      #temperature.critical {
          color: @red;
          border-bottom: 2px solid @red;
      }

      #bluetooth {
          border-bottom: 2px solid @blue;
      }

      #battery {
          border-bottom: 2px solid @yellow;
      }

      #battery.charging {
          border-bottom: 2px solid @bright_yellow;
      }

      #battery.100 {
          border-bottom: 2px solid @bright_green;
      }

      #battery.20:not(.charging), #battery.10:not(.charging) {
          color: @red;
          border-bottom: 2px solid @red;
          animation: blink 1s linear infinite;
      }

      @keyframes blink {
          50% {
              opacity: 0;
          }
      }

      #network {
          border-bottom: 2px solid @magenta;
      }

      #wireplumber {
          border-bottom: 2px solid @bright_magenta;
      }

      #wireplumber.muted {
          color: @orange;
          border-bottom: 2px solid @orange;
      }

      #custom-weather {
          border-bottom: 2px solid @bright_blue;
      }

      #clock {
          border-bottom: 2px solid @bright_orange;
      }
    '';
  };
}
