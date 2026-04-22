{
  options,
  config,
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;

  ndg = import "${sources.ndg}/nix/internal/packages.nix" pkgs;
  docs = ndg.ndg-builder.override {
    rawModules = singleton {
      options = options.self;
    };
  };
in
{
  config = mkIf config.self.docs.enable {
    environment.etc."nixos/docs".source = docs;
  };
}
