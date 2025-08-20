{
  perSystem = {
    inputs',
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShellNoCC {
      packages = [
        inputs'.agenix.packages.default # agenix CLI for managing secrets
        pkgs.git
      ];
    };
  };
}
