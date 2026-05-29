{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;
in
{
  config = mkIf config.self.docs.enable {
    environment.etc."nixos/docs".source = pkgs.docs;
    environment.systemPackages = singleton (
      pkgs.writeShellScriptBin "docs" "xdg-open /etc/nixos/docs/options.html"
    );
  };
}
