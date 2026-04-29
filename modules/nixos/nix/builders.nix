# TODO: not yet activated
# based on:
# - https://nix.dev/tutorials/nixos/distributed-builds-setup.html
# - notashelf/nyx
#   - /modules/core/common/system/nix/builders.nix
#   - /modules/core/common/system/os/users/builder.nix
{
  config,
  keys,
  lib,
  ...
}:
let
  inherit (lib.attrsets) recursiveUpdate;

  genericBuilder = {
    # system = pkgs.stdenv.hostPlatform.system;
    systems = [ "x86_64-linux" ];
    speedFactor = 4;
    maxJobs = 4;
    supportedFeatures = [
      "benchmark"
      "nixos-test"

      "kvm"
      "big-parallel"
    ];
    sshKey = "/home/${config.self.user.name}/.ssh/builder";
    sshUser = "builder";
  };

  bigBuilder = recursiveUpdate genericBuilder {
    maxJobs = 16;
    speedFactor = 16;
    supportedFeatures = genericBuilder.supportedFeatures ++ [
      "kvm"
      "big-parallel"
    ];
    systems = genericBuilder.systems ++ [
      "aarch64-linux"
      "i686-linux"
    ];
  };

  mkBuilder =
    {
      builder ? genericBuilder,
      sshProtocol ? "ssh-ng",
      hostName,
      ...
    }:
    recursiveUpdate builder {
      inherit hostName;
      protocol = sshProtocol;
    };

  sshOpts = ''command="nix-daemon --stdio",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding'';
  mkBuilderKeys = keys: map (key: "${sshOpts} ${key}") keys;
in
{
  config = lib.mkIf false {
    users = {
      groups.builder = { };
      users.builder = {
        useDefaultShell = false;
        isSystemUser = true;
        createHome = true;
        group = "builder";
        home = "/var/empty";
        openssh.authorizedKeys.keys = mkBuilderKeys keys.${config.self.user.name};
      };
    };

    nix = {
      distributedBuilds = true;
      buildMachines = builtins.filter (builder: builder.hostName != config.networking.hostName) [
        (mkBuilder {
          # builder = bigBuilder;
          hostName = "AuroraR7";
          # sshProtocol = "ssh";
        })
      ];
      settings.trusted-users = [ "builder" ];
    };
  };
}
