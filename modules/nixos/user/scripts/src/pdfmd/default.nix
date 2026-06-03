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
  ];
  text = ''
    pandoc "$@" -o "$(printf '%s' "$1" | sed 's/.md/.pdf/g') -V geometry:margin=1in"
  '';
}
