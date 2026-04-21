{
  inputs,
  pins,
  self,
  ...
}:
let
  inherit (inputs) nixpkgs;
  inherit (self.flake) compat;

  fc = import pins.flake-compat;
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
    (fc {
      inherit src system;
      impureOverrides = inputsOverrides // {
        inherit nixpkgs;
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
