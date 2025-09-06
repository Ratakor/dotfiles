{
  perSystem = {
    config,
    pkgs,
    self',
    ...
  }: {
    devShells.default = pkgs.mkShellNoCC {
      name = "dotfiles";

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
