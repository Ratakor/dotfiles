{
  environment = {
    variables = {
      EDITOR = "nvim";

      # MANPAGER = "nvim -c 'set ft=man bt=nowrite noswapfile nobk shada=\\\"NONE\\\" ro noma' +Man! -o -";
    };

    # binsh = "${pkgs.dash}/bin/dash";
    localBinInPath = true;
    homeBinInPath = false;
    # memoryAllocator.provider = "graphene-hardened";
    enableAllTerminfo = false;
    enableDebugInfo = false; # see wiki to enable debug info per package instead
    extraOutputsToInstall = [ ]; # enable it per package instead like `pkg.dev`
  };
}
