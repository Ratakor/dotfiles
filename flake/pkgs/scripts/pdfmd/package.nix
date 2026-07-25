# convert markdown to pdf with pandoc
# assuming that first argument is the markdown file
{
  writeShellApplication,
  pandoc,
  gnused,
}:
writeShellApplication {
  name = "pdfmd";
  runtimeInputs = [
    pandoc
    gnused
    # also needs pdflatex and stuff from texliveSmall
  ];
  text = ''
    pandoc "$@" -o "$(printf '%s' "$1" | sed 's/.md/.pdf/g')" -V geometry:margin=1in
  '';
  meta.mainProgram = "pdfmd";
}
