pkgs:
let
  callApps =
    apps:
    builtins.listToAttrs (
      map (app: {
        name = app;
        value = {
          type = "app";
          program = import ./${app}/app.nix { inherit pkgs; };
          meta.description = app;
        };
      }) apps
    );
in
callApps [
  "confloose"
]
