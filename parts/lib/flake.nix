{ self, sources, ... }:
let
  inherit (self.flake) compat;

  flake-compat = import sources.flake-compat;
in
{
  /**
    Given a path to a flake directory and optional inputs overrides,
    returns the evaluated outputs.
  */
  compat =
    {
      src,
      inputsOverrides ? { },
      system ? builtins.currentSystem or "unknown-system",
    }:
    (flake-compat {
      inherit src system;
      impureOverrides = inputsOverrides // {
        inherit (sources) nixpkgs;
      };
    }).defaultNix;

  /**
    Given a path to a flake directory, returns the evaluated outputs.
  */
  compat' = src: compat { inherit src; };

  /**
    Returns the default package of `src` for `system` with optional inputs
    overrides when evaluating the flake.
  */
  package =
    src: system: inputsOverrides:
    (compat { inherit src inputsOverrides system; }).default;
}
