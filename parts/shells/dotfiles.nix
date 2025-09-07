{
  mkShellNoCC,
  git,
  agenix,
  npins,
  just,
  nh,
}:
mkShellNoCC {
  name = "dotfiles";

  # shellHook = ''
  #   ${config.pre-commit.installationScript}
  # '';

  packages = [
    git
    agenix
    npins
    just
    nh
  ];
}
