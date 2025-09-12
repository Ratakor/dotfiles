{
  pkgs,
  self,
  ...
}:
let
  inherit (self.lib.trivial) isx86Linux;
in
{
  imports = [
    ./wireplumber.nix
  ];

  # TODO: only enable if system has sound
  config = {
    services.pipewire = {
      enable = true;
      audio.enable = true;

      alsa = {
        enable = true;
        support32Bit = isx86Linux pkgs;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    systemd.user.services = {
      pipewire.wantedBy = [ "default.target" ];
      pipewire-pulse.wantedBy = [ "default.target" ];
    };
  };
}
