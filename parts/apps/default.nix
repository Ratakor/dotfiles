{
  perSystem =
    { pkgs, ... }:
    let
      callApps =
        apps:
        apps
        |> map (app: {
          name = app;
          value = {
            type = "app";
            program = import ./${app}/app.nix { inherit pkgs; };
          };
        })
        |> builtins.listToAttrs;
    in
    {
      apps = callApps [
        "confloose"
      ];
    };
}
