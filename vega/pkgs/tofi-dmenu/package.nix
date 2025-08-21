{tofi, ...}:
tofi.overrideAttrs (oldAttrs: {
  pname = "tofi-dmenu";
  patches = (oldAttrs.patches or []) ++ [./tofi-dmenu-20240910.diff];
})
