{
  lib,
  pkgs,
  sources,
  self,
  ...
}:
let
  # This depends on `ndg` being in `pkgs`.
  ndg-builder = pkgs.callPackage "${sources.ndg}/nix/packages/ndg-builder/package.nix" { };

  eval = import "${sources.nixpkgs}/nixos/lib/eval-config.nix" {
    inherit lib pkgs;
    system = null;
    modules = lib.listModuleFiles (self + /modules/options);
    specialArgs = {
      inherit sources;
      inherit (self) keys;
    };
  };
in
ndg-builder.override {
  evaluatedModules.options.self = eval.options.self;
  moduleName = "self";
  basePath = self;
  repoPath = "https://github.com/ratakor/dotfiles/blob/nixos";
  title = "Self";
  description = "Options available via config.self";
}
