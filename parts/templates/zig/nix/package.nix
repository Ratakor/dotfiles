{
  lib,
  zigPlatform,
}: let
  fs = lib.fileset;
in
  zigPlatform.makePackage rec {
    pname = "zig-template";
    # Must match the `version` in `build.zig.zon`.
    version = "0.1.0-dev";

    src = fs.toSource {
      root = ../.;
      fileset = fs.unions [
        ../src
        ../build.zig
        ../build.zig.zon
      ];
    };

    # depsHash = "<replace this with the hash Nix provides in its error message>"
    zigReleaseMode = "fast";
    zigFlags = ["-Dversion-string=${version}"];
  }
