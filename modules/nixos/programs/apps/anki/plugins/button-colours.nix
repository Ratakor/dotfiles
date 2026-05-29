{ config, pkgs, ... }:
let
  colors = config.self.colors.default;

  button-colours = pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
    pname = "button-colours";
    version = "0-unstable-2025-09-25";
    src = pkgs.fetchFromGitHub {
      owner = "teaqu";
      repo = "anki-button-colours";
      rev = "8dcd2aa804d7834e4ca7622dcf0dff2d6fa46493";
      hash = "sha256-H40rZny38h7IDhl6o9vWn3kbvDbAWcAp++UriR2LtHg=";
    };
    sourceRoot = "${finalAttrs.src.name}/button_colours";
  });
in
button-colours.withConfig {
  config = {
    # idk if this should be the same as colours-dark
    colours = {
      "2 answers" = [
        "red"
        "green"
      ];
      "3 answers" = [
        "red"
        "green"
        "blue"
      ];
      "4 answers" = [
        "red"
        "darkorange"
        "green"
        "blue"
      ];
    };
    colours-dark = {
      "2 answers" = [
        colors.red
        colors.green
      ];
      "3 answers" = [
        colors.red
        colors.green
        colors.blue
      ];
      "4 answers" = [
        colors.red
        colors.orange
        colors.green
        colors.blue
      ];
    };
  };
}
