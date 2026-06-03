{ lib, ... }:
let
  inherit (lib.options) mkEnableOption;

  mkEnableOption' = desc: mkEnableOption desc // { default = true; };
in
{
  options.self.programs.scripts = {
    enable = mkEnableOption "scripts";

    ocr.enable = mkEnableOption' "ocr";
    pdfmd.enable = mkEnableOption' "pdfmd";

    randwp.enable = mkEnableOption "randwp";
  };
}
