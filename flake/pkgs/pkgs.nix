{
  lib,
  sources,
  overlay,
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
    overlay

    # Replace nixpkgs' pristine lib with our filthy one
    (_final: _prev: { inherit lib; })

    # Replace _all_ instances of nix with latest lix.
    (final: prev: {
      inherit (prev.lixPackageSets.latest) lix;
      nix = final.lix;
    })

    # Replace nix-output-monitor ugly icons.
    (_final: prev: {
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

    # Helium Browser
    (_final: _prev: {
      helium = sources.helium.packages.${system}.default;
    })

    # https://github.com/NixOS/nixpkgs/issues/513245#issuecomment-4320293674
    (_final: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };
    })
  ];
}
