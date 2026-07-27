sources:
(import "${sources.nixpkgs}/lib").extend (
  self: lib:
  let
    inherit (builtins) attrNames removeAttrs readDir;
    inherit (lib.attrsets) genAttrs';
  in
  # me when I overcomplicate things for no reason
  (genAttrs' (attrNames (removeAttrs (readDir ./.) [ "default.nix" ])) (
    file:
    let
      # name = lib.strings.removeSuffix ".nix" file; # infinite recursion
      name = builtins.substring 0 ((builtins.stringLength file) - 4) file;
    in
    {
      inherit name;
      value = (lib.${name} or { }) // (import ./${name}.nix { inherit lib sources self; });
    }
  ))
  // {
    inherit (self.filesystem)
      listFiles
      listDirs
      filterNixFiles
      listModuleFiles
      listFilesRecursive
      ;
    inherit (self.lists) ifold0 ifold1;
    inherit (self.options)
      enumOptionValues
      enumOptionValues'
      mkEnableOptions
      mkEnableOptions'
      mkCommandOption
      ;
    inherit (self.trivial)
      capitalize
      hexToRgba
      isx86Linux
      unreachable
      shortRev
      ;
    inherit (self.types) enumValues unwrapNullOr;

    # wlib
    wrappers = import "${sources.nix-wrapper-modules}/lib" { inherit lib; };
    mkWrapper = self.wrappers.evalPackage; # should we include self.wrappers.modules.default?
    mkWrapperFor =
      name: module:
      (self.wrappers.evalModules {
        modules = [
          # we can't `{ inherit pkgs; }` sadly
          self.wrappers.wrapperModules.${name}
          module
        ];
      }).config.wrapper;
  }
)
