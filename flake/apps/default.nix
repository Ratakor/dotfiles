{ lib }:
pkgs:
let
  callApps =
    apps:
    lib.genAttrs apps (app: {
      type = "app";
      program = import ./${app}/app.nix { inherit lib pkgs; };
      meta.description = app;
    });
in
callApps [
  "confloose"
]
