{
  perSystem = {
    config,
    pkgs,
    self',
    ...
  }: {
    devShells.default = pkgs.mkShellNoCC {
      # shellHook = ''
      #   ${config.pre-commit.installationScript}
      # '';

      packages = with pkgs; [
        git
        self'.packages.agenix
        npins
        just
        nh
      ];
    };
  };
}
