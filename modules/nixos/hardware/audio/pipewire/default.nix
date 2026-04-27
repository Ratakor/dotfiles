{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.trivial) isx86Linux;
  inherit (lib.modules) mkIf mkForce;

  cfg = config.self.system.audio;
in
{
  imports = [
    ./wireplumber.nix
  ];

  config = mkIf cfg.enable {
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

    # Required by pipewire
    security.rtkit.enable = mkForce config.services.pipewire.enable;
  };
}
