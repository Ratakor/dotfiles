{
  perSystem = {
    inputs',
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShellNoCC {
      # shellHook = ''
      #   ${config.pre-commit.installationScript}
      # '';

      packages = with pkgs; [
        inputs'.agenix.packages.default # agenix CLI for managing secrets
        git
        npins
      ];
    };
  };
}
