# Duplicate systemd-services from home-manager to xdg.dataFile
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) replaceStrings isBool concatLists listToAttrs;
  inherit (lib.generators) toINI;
  inherit (lib.lists) singleton;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.modules) mkMerge;

  cfg = config.systemd.user;

  # From <nixpkgs/nixos/modules/system/boot/systemd-lib.nix>
  mkPathSafeName = replaceStrings ["@" ":" "\\" "[" "]"] ["-" "-" "-" "" ""];

  toSystemdIni = toINI {
    listsAsDuplicateKeys = true;
    mkKeyValue = key: value: let
      value' =
        if isBool value
        then
          (
            if value
            then "true"
            else "false"
          )
        else toString value;
    in "${key}=${value'}";
  };

  buildService = style: name: serviceCfg: let
    filename = "${name}.${style}";
    pathSafeName = mkPathSafeName filename;

    # Needed because systemd derives unit names from the ultimate
    # link target.
    source =
      pkgs.writeTextFile {
        name = pathSafeName;
        text = toSystemdIni serviceCfg;
        destination = "/${filename}";
      }
      + "/${filename}";

    install = variant: target: {
      name = "systemd/user/${target}.${variant}/${filename}";
      value = {inherit source;};
    };
  in
    singleton {
      name = "systemd/user/${filename}";
      value = {inherit source;};
    }
    ++ map (install "wants") (serviceCfg.Install.WantedBy or [])
    ++ map (install "requires") (serviceCfg.Install.RequiredBy or []);
  buildServices = style: serviceCfgs: concatLists (mapAttrsToList (buildService style) serviceCfgs);
in {
  xdg.dataFile = mkMerge [
    (lib.listToAttrs (
      (buildServices "service" cfg.services)
      ++ (buildServices "slice" cfg.slices)
      ++ (buildServices "socket" cfg.sockets)
      ++ (buildServices "target" cfg.targets)
      ++ (buildServices "timer" cfg.timers)
      ++ (buildServices "path" cfg.paths)
      ++ (buildServices "mount" cfg.mounts)
      ++ (buildServices "automount" cfg.automounts)
    ))
  ];
}
