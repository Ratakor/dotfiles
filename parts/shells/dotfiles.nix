{
  mkShellNoCC,
  git,
  agenix, # agenix-cli in nixpgks
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
    # nh # TODO: this uses the wrong nix-output-monitor
  ];
}
