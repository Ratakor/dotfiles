{
  host ? "unknown-host",
  system ? "x86_64-linux",
}@args:
let
  self = import ../. { }; # builtins.getFlake (toString ../.);
  hosts = builtins.mapAttrs (name: value: value.config) self.nixosConfigurations;
  host = self.nixosConfigurations.${args.host};
  lib = host.lib.extend (final: prev: { self = self.lib; });
in
hosts
// {
  inherit (self) sources keys;
  inherit (host) config options pkgs;
  inherit self host lib;
  packages = self.packages.${system};
  # pkgs = self.legacyPackages.${system};
}
