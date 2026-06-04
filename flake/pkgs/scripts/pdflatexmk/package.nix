# from https://github.com/NotAShelf/nyx/tree/main/homes/notashelf/packages/dev/default.nix
{
  writeShellApplication,
  texlivePackages,
}:
writeShellApplication {
  name = "pdflatexmk";
  runtimeInputs = [ texlivePackages.latexmk ];
  text = ''
    latexmk -pdf "$@" && latexmk -c "$@"
  '';
  meta.mainProgram = "pdflatexmk";
}
