# https://yalter.github.io/niri/Configuration:-Layer-Rules
config:
let
  # X200 doesn't support blur, probably because of Smithay #1595
  # btw this does look stupid but it's _almost_ the same code as
  # lib.boolToString because builtins.toString turns bools into 0 or 1 :)
  enable-blur = if config.networking.hostName == "X200" then "false" else "true";
in
# kdl
''
  layer-rule {
    match namespace="^launcher$"

    // opacity is managed by the application
    // opacity 0.75

    shadow {
      on
    }

    // idk if I like it
    // baba-is-float true

    background-effect {
      blur ${enable-blur}
      xray false
      // saturation 3
    }
  }
''
