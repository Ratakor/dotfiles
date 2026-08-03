{
  sources,
  stdenv,
}:
sources.noctalia.packages.${stdenv.hostPlatform.system}.default.overrideAttrs (prevAttrs: {
  patches = (prevAttrs.patches or [ ]) ++ [
    ./helix-template.diff
  ];
})
