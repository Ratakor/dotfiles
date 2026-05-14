{ tofi }:
tofi.overrideAttrs (prevAttrs: {
  pname = "tofi-dmenu";
  patches = (prevAttrs.patches or [ ]) ++ [ ./tofi-dmenu-0.9.1.diff ];
})
