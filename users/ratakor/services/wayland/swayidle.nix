# Idle manager
{pkgs, ...}: {
  home.packages = [pkgs.swayidle];

  services.swayidle = {
    enable = false; # This shit doesn't work
    extraArgs = ["-w"];
    timeouts = [
      {
        timeout = 300;
        command = "glitchlock";
      }
      {
        timeout = 600;
        command = "${pkgs.wlopm}/bin/wlopm --off '*'";
        resumeCommand = "${pkgs.wlopm}/bin/wlopm --on '*'";
      }
      # { timeout = 600; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };
}
