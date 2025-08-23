{
  pkgs,
  vega,
  ...
}: {
  home.packages = with pkgs; [
    rustup # rust
    nasm # x86 compiler
    gcc # gnu compiler collection
    # clang # another cc + clangd C lsp
    tinycc # tiny c compiler
    # mingw-w64-gcc # windows cc (NOT IN NIX?)
    musl # another libc
    libbsd # Common functions found on BSD systems
    zig # use zig-overlay per project for a specific version
    python3
    pipx # python package manager
    astyle # C formatter
    shellcheck # there is also shellcheck-minimal in nixpkgs
    cmake
    gdb
    # qemu_full
    dosfstools
    mtools
    libisoburn # xorriso
    gptfdisk
    sshfs # mount drive over ssh
    ntfs3g # ntfs filesystem (windows compatibility)
    xfsprogs # xfs filesystem
    xfsdump # xfs snapshots
    # jdk17-openjdk # java (this is the wrong package btw)
    # perf # performance analysis tool (wrong package)
    hyperfine # benchmarking tool
    # poop # Performance Optimizer Observation Platform
    # nodePackages.nodejs # javascript (I have no clue about all these nodePackages)
    nodePackages.npm
    nodePackages.pnpm
    lua
    luarocks # lua package manager
    just # command runner (like make)
    cloc # counts lines of code
    checkbashisms # checks for bashisms in scripts
    # love # lua 2D game engine (Balatro)
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    ## archives
    bzip2
    gzip
    zip
    unzip
    p7zip
    xz
    zstd
    lz4
    ouch # Obvious Unified Compression Helper

    ## nix tools
    alejandra # formatter
    statix # linter
    deadnix # find and remove unused code in .nix source files
    nh # nix helper # TODO: programs.nh (system wide)
    # comma
    # nix-output-monitor # replace `nix` with `nom`
    # nurl
    vega.pkgs.flint # flake linter
  ];

  programs = {
    # LaTeX
    texlive = {
      enable = true;
      # package = pkgs.texliveMinimal; # pkgs.texliveFull;
    };

    # Conversion between documentation formats
    pandoc = {
      enable = true;
      # TODO: config
    };

    # Go Programming Language
    go = {
      enable = true;
      # goPath = "${config.xdg.dataHome}/go";
      # telemetry.mode = "off";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true; # adds a hook to enable direnv with zsh
      silent = true;
      # config = {};
    };
  };

  # home.file."${cargoHome}/cargo.toml".text = ''
  #   [net]
  #   git-fetch-with-cli = true
  # '';
}
