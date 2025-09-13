{ pkgs, ... }:
let
  simp1e-cursors = pkgs.simp1e-cursors.overrideAttrs (prevAttrs: {
    patches = (prevAttrs.patches or [ ]) ++ [
      ./Simp1e-Dracula.diff
      ./Simp1e-Remove-Themes.diff
    ];
  });
in
{
  environment.systemPackages = [
    # pkgs.posy-cursors
    # pkgs.apple-cursor
    simp1e-cursors
  ];
}
