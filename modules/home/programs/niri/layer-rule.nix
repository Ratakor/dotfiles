# https://yalter.github.io/niri/Configuration:-Layer-Rules
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
      blur true
      xray false
      // saturation 3
    }
  }
''
