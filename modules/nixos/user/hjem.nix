{
  config,
  lib,
  sources,
  ...
}:
let
  inherit (lib.modules) mkAliasOptionModule;

  username = config.self.user.name;
in
{
  imports = [
    (import "${sources.hjem}/modules/nixos").default
    (mkAliasOptionModule [ "hj" ] [ "hjem" "users" username ])
  ];

  hjem.clobberByDefault = true;
}
