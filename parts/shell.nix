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
        git
        inputs'.agenix.packages.default # agenix CLI for managing secrets
        npins
        just
        nh
      ];
    };
  };
}
