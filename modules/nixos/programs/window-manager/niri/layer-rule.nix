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

  // https://docs.noctalia.dev/noctalia/compositor-settings/niri/?section=option-1-blurred-overview-wallpaper#option-1-blurred-overview-wallpaper
  layer-rule {
    match namespace="^noctalia-backdrop"
    place-within-backdrop true
  }

  // https://docs.noctalia.dev/noctalia/compositor-settings/niri/?section=blur#blur
  layer-rule {
    match namespace="^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"
    background-effect {
      xray false
      // blur false
    }
  }

  // noctalia msg window-switcher
  // kinda better than niri's native window switcher
  layer-rule {
    match namespace="noctalia-window-switcher"
    background-effect {
        blur true
        xray false
    }
  }
''
