{ lib, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  security = {
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

      extraRules =
        let
          mkNopassRule = command: {
            command = "/run/current-system/sw/bin/${command}";
            options = [ "NOPASSWD" ];
          };
        in
        [
          {
            groups = [ "wheel" ];
            commands = map mkNopassRule [
              # "nixos-rebuild"
              # "systemctl"
              # "sync" # this is probably a security hole since sync is symlinked to coreutils
              "dmesg"
            ];
          }
        ];
    };
  };
}
