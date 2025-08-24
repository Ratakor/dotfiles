{
  documentation = {
    # Whether to install documentation of packages from `environment.systemPackages`.
    enable = true;

    # Whether to install documentation targeted at developers.
    dev.enable = true;

    # Whether to install the "doc" output of packages.
    # Usually plain text and/or HTML located in `${pkg}/share/`.
    doc.enable = false;

    # Whether to install the `info` command and the "info" output of packages.
    info.enable = false;

    man = {
      # Whether to install manual pages and the "man" output of packages.
      enable = true;

      # Which man page processor to use.
      man-db.enable = true;
      mandoc.enable = false; # sadly mandoc is poorly supported on nixos

      # Whether to generate the manual page index caches.
      # This allows searching for a page or keyword using utilities like
      # `apropos(1)` and the `-k` option of `man(1)`.
      generateCaches = true;
    };

    nixos = {
      # Whether to install NixOS's own documentation.
      # This includes:
      # - Pages like `configuration.nix(5)` if `man.enable` is set.
      # - The HTML manual and the `nixos-help` command if `doc.enable` is set.
      enable = true;

      # Whether the generated NixOS's documentation should include
      # documentation for all the options from all the NixOS modules included
      # in the current `configuration.nix`.
      # Default: false
      includeAllModules = false;
    };
  };
}
