{
  lib,
  self,
  sources,
}:
let
  inherit (builtins) elem concatStringsSep;
  inherit (lib.lists) length zipListsWith;
  inherit (lib.strings) getName escapeShellArg;
  inherit (lib.trivial) warnIfNot;

  # I kinda dislike this
  acknowledgedUnfreePackages = [
    # apps
    "discord"
    "spotify"
    "ouch" # rar
    "osu-lazer-bin"

    # steam
    "steam"
    "steam-unwrapped"

    # chromium drm
    "widevine-cdm"

    # nvidia
    "nvidia-kernel-modules"
    "nvidia-x11"

    # cuda (ollama)
    "cuda_cudart"
    "cuda_compat"
    "cuda_nvcc"
    "cuda_cccl"
    "libcublas"

    # smh gemini was open source but not agy :(
    "antigravity-cli"

    # onlyoffice fonts
    "corefonts"
  ];
in
system:
import sources.nixpkgs {
  inherit system;

  # https://nixos.org/manual/nixpkgs/unstable/#chap-packageconfig
  # https://nixos.org/manual/nixpkgs/unstable/#sec-config-options-reference
  config = {
    # Whether to allow broken packages.
    # See https://nixos.org/manual/nixpkgs/stable/#sec-allow-broken.
    # Default: false || builtins.getEnv "NIXPKGS_ALLOW_BROKEN" == "1"
    allowBroken = false;

    # Whether to allow unfree packages.
    # See https://nixos.org/manual/nixpkgs/stable/#sec-allow-unfree.
    # Default: false || builtins.getEnv "NIXPKGS_ALLOW_UNFREE" == "1"
    # allowUnfree = true;
    allowUnfreePredicate =
      pkg:
      let
        pkgName = getName pkg;
      in
      warnIfNot (elem pkgName acknowledgedUnfreePackages) "Allowing unfree package: ${pkgName}" true;

    # Whether to allow unsupported systems.
    # See https://nixos.org/manual/nixpkgs/stable/#opt-allowUnsupportedSystem
    # This is useful for cross-compilation.
    # Default: false || builtins.getEnv "NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM" == "1"
    allowUnsupportedSystem = false; # this is broking cuda_compat

    # Whether to warn when config contains an unrecognized attribute.
    # This is so stupid it can't even recognise valid attributes.
    # Default: false
    warnUndeclaredOptions = false;

    # Whether to expose old attribute names for compatibility.
    #
    # The recommended setting is to enable this, as it improves backward
    # compatibility, easing updates.
    #
    # The only reason to disable aliases is for continuous integration
    # purposes. For instance, Nixpkgs should not depend on aliases in its
    # internal code. Projects that aren’t Nixpkgs should be cautious of
    # instantly removing all usages of aliases, as migrating too soon can
    # break compatibility with the stable Nixpkgs releases.
    #
    # Default: true
    allowAliases = false;
  };

  overlays = [
    self.overlays.default

    (final: prev: {
      # Replace nixpkgs' pristine lib with our filthy one
      inherit lib;

      # Replace _all_ instances of nix with latest lix.
      inherit (prev.lixPackageSets.latest) lix;
      nix = final.lix;

      # Helium Browser
      helium = sources.helium.packages.${system}.default;

      # Wallpapers, adds pkgs.wallpapers which is like 1GB
      wallpapers = sources.wallpapers.packages.${system}.default;

      # Replace nix-output-monitor ugly icons.
      nix-output-monitor =
        let
          oldIcons = [
            "↑"
            "↓"
            "⏱"
            "⏵"
            "✔"
            "⏸"
            "⚠"
            "∅"
            "∑"
          ];
          newIcons = [
            "f062" # 
            "f063" # 
            "f520" # 
            "f04b" # 
            "f00c" # 
            "f04c" # 
            "f071" # 
            "f1da" # 
            "f04a0" # 󰒠
          ];
        in
        assert length oldIcons == length newIcons;
        prev.nix-output-monitor.overrideAttrs (prevAttrs: {
          postPatch = (prevAttrs.postPatch or "") + ''
            sed -i ${
              escapeShellArg (concatStringsSep "\n" (zipListsWith (a: b: "s/${a}/\\\\x${b}/") oldIcons newIcons))
            } lib/NOM/Print.hs

            substituteInPlace lib/NOM/Print/Tree.hs --replace-fail '┌' '╭'
          '';
        });
    })
  ];
}
