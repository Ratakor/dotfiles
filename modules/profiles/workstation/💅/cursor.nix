{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.strings) toSentenceCase;

  mkScheme =
    variant:
    let
      Variant = toSentenceCase variant;
      colors = config.self.colors.${variant};
    in
    pkgs.writeText "Simp1e-${Variant}.txt" ''
      name:Simp1e ${Variant}

      shadow:${colors.background}
      shadow_opacity:0.35

      cursor_border:${colors.foreground}

      default_cursor_bg:${colors.background}
      hand_bg:${colors.background}

      question_mark_bg:${colors.cyan}
      question_mark_fg:${colors.background}

      plus_bg:${colors.green}
      plus_fg:${colors.background}

      link_bg:${colors.magenta}
      link_fg:${colors.background}

      move_bg:${colors.yellow}
      move_fg:${colors.background}

      context_menu_bg:${colors.blue}
      context_menu_fg:${colors.background}

      forbidden_bg:${colors.background}
      forbidden_fg:${colors.red}

      magnifier_bg:${colors.background}
      magnifier_fg:${colors.foreground}

      skull_bg:${colors.background}
      skull_eye:${colors.foreground}

      spinner_bg:${colors.background}
      spinner_fg1:${colors.foreground}
      spinner_fg2:${colors.foreground}
    '';

  simp1e-cursors = pkgs.simp1e-cursors.overrideAttrs (prevAttrs: {
    preBuild = (prevAttrs.preBuild or "") + ''
      rm ./src/templates/left.svg
      rm ./src/color_schemes/*
      cp ${mkScheme "dark"} ./src/color_schemes/Simp1e-Dark.txt
      cp ${mkScheme "light"} ./src/color_schemes/Simp1e-Light.txt
    '';
  });
in
{
  environment.systemPackages = [
    # pkgs.posy-cursors
    # pkgs.apple-cursor
    simp1e-cursors
  ];
}
