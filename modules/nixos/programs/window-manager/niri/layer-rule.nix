# https://yalter.github.io/niri/Configuration:-Layer-Rules
{ ... }:
# kdl
''
  layer-rule {
    match namespace="^launcher$"
    match namespace="^walker$"

    // opacity is managed by the application
    // opacity 0.75

    shadow {
      on
    }

    // idk if I like it
    // baba-is-float true

    background-effect {
      blur true
      xray false
      // saturation 3
    }
  }

  // https://docs.noctalia.dev/v5/compositor-settings/niri/?section=option-1-blurred-overview-wallpaper#option-1-blurred-overview-wallpaper
  layer-rule {
    match namespace="^noctalia-backdrop"
    place-within-backdrop true
  }
''
