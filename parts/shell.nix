{
  perSystem = {
    config,
    pins,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShellNoCC {
      # shellHook = ''
      #   ${config.pre-commit.installationScript}
      # '';

      packages = with pkgs; [
        git
        (pkgs.callPackage "${pins.agenix}/pkgs/agenix.nix" {}) # agenix CLI for managing secrets
        npins
        just
        nh
      ];
    };
  };
}
