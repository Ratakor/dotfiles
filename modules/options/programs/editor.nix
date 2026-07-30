{ config, lib, ... }:
let
  inherit (lib.options) mkProgram;

in
{
  imports = [
    (mkProgram config "editor" {
      values = [
        "helix"
        "micro"
      ];
      default = "helix";
      nullable = false;
      hasPackage = true;
    })

    (mkProgram config "visual editor" {
      values = [
        "zed"
      ];
      optionPath = [
        "editor"
        "visual"
      ];
      nullable = true;
      hasPackage = true;
    })
  ];
}
