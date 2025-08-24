{
  lib,
  vega,
  ...
}: let
  inherit (lib.meta) getExe';
  inherit (lib.modules) mkForce;
in {
  security = {
    # polkit.enable = true; # TODO: what is it for except niri?

    rtkit.enable = true; # needed by pipewire

    # keep the set even if empty to make swaylock work
    pam.services.swaylock = {
      fprintAuth = false;
    };

    wrappers = let
      mkSetuidWrapper = package: command: {
        setuid = true;
        owner = "root";
        group = "root";
        source = getExe' package command;
      };
    in {
      pmount = mkSetuidWrapper vega.pkgs.pmount "pmount";
      pumount = mkSetuidWrapper vega.pkgs.pmount "pumount";
    };

    # https://github.com/NixOS/nixpkgs/pull/256491
    sudo-rs.enable = mkForce false;

    sudo = {
      enable = true;

      # wheelNeedsPassword = false; # allow wheel group to run sudo without password
      execWheelOnly = true;

      extraConfig = ''
        Defaults env_keep += "EDITOR" # PATH DISPLAY
        Defaults lecture = never
        Defaults passprompt = "sudo (%p@%h) password: "
      '';

      extraRules = let
        mkNopassRule = command: {
          command = "/run/current-system/sw/bin/${command}";
          options = ["NOPASSWD"];
        };
      in [
        {
          groups = ["wheel"];
          commands = map mkNopassRule [
            # "nixos-rebuild"
            # "systemctl"
            "sync"
            "dmesg"
          ];
        }
      ];
    };
  };
}
