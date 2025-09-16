# Media Player
{ pkgs, ... }:
{
  hm.programs.mpv = {
    enable = true;
    # defaultProfiles = ["gpu-hq"];
    bindings = {
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
      l = "seek 5";
      h = "seek -5";
      j = "seek 60";
      k = "seek -60";
    };
    scripts = with pkgs.mpvScripts; [
      reload
      sponsorblock-minimal
      # skipsilence
      # mpv-notify-send
    ];
    profiles = {
      # mpv --profile=yt <url>
      yt = {
        ytdl-raw-options = "cookies-from-browser=chromium";
      };
    };
  };

  hm.xdg.configFile."mpv/scripts/copy_path.lua".text =
    # lua
    ''
      local mp = require("mp")

      local function copy_path()
        local path = mp.get_property("path")
        mp.osd_message(string.format("Copied to clipboard: %s", path))
        os.execute("printf '%s' " .. path .. " | wl-copy")
      end

      mp.add_key_binding("y-y", "copy_path", copy_path)
    '';
}
