{
  host ? "unknown-host",
  system ? "x86_64-linux",
}@args:
let
  self = import ../. { }; # builtins.getFlake (toString ../.);
  hosts = builtins.mapAttrs (name: value: value.config) self.nixosConfigurations;
  host = self.nixosConfigurations.${args.host};
in
hosts
// {
  inherit (self) sources keys lib;
  inherit (host) config options pkgs;
  inherit (host.pkgs) wrappers;
  inherit self host;
  packages = self.packages.${system};
}
