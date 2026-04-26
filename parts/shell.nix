{
  self ? import ../. { },
  system ? builtins.currentSystem,
  pkgs ? self.legacyPackages.${system},
}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    git
    agenix
    npins
    just
    nh
  ];

  # shellHook = ''
  #   ${config.pre-commit.installationScript}
  # '';
}
