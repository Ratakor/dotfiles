{
  lib,
  pkgs,
  sources,
  self,
  ...
}:
let
  inherit (lib.lists) singleton;

  # This depends on `ndg` being in `pkgs`.
  ndg-builder = pkgs.callPackage "${sources.ndg}/nix/packages/ndg-builder/package.nix" { };

  eval = import "${sources.nixpkgs}/nixos/lib/eval-config.nix" {
    inherit lib pkgs;
    system = null;
    modules = singleton (self + /modules/options);
    specialArgs = {
      inherit sources;
    };
  };
in
ndg-builder.override {
  rawModules = singleton { options.self = eval.options.self; };
  moduleName = "self"; # idk
  repoPath = "https://github.com/ratakor/dotfiles/blob/nixos";
  title = "Self";
  description = "Options available via config.self";
}
