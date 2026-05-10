{
  config,
  lib,
  options,
  pkgs,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;

  # This depends on `ndg` being in `pkgs`.
  ndg-builder = pkgs.callPackage "${sources.ndg}/nix/packages/ndg-builder/package.nix" { };
in
{
  config = mkIf config.self.docs.enable {
    environment.etc."nixos/docs".source = ndg-builder.override {
      rawModules = singleton { options = options.self; };
      moduleName = "self"; # idk
      repoPath = "https://github.com/ratakor/dotfiles/blob/nixos";
      title = "Self";
      description = "Options available via config.self";
    };
    environment.systemPackages = singleton (
      pkgs.writeShellScriptBin "docs" "xdg-open /etc/nixos/docs/options.html"
    );
  };
}
