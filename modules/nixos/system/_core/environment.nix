{
  environment = {
    variables = {
      EDITOR = "hx";
    };

    localBinInPath = true;
    homeBinInPath = false;
    enableAllTerminfo = false;
    enableDebugInfo = false; # see wiki to enable debug info per package instead
    extraOutputsToInstall = [ ]; # enable it per package instead like `pkg.dev`

    # Both of these options can be set for performance concerns but your system will break.
    # binsh = "${pkgs.dash}/bin/dash";
    # memoryAllocator.provider = "mimalloc"; # "graphene-hardened";
  };
}
