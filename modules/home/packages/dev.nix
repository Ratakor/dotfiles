{
  pkgs,
  self,
  ...
}: let
  toolchains = with pkgs; [
    cargo # rust package manager
    rustc # rust compiler
    go # golang
    nasm # x86 compiler
    gcc # gnu compiler collection
    # clang # another cc + clangd C lsp
    tinycc # tiny c compiler
    # windows.mingw_w64 # windows cc (mingw-w64-gcc)
    # musl # another libc
    libbsd # Common functions found on BSD systems
    zig # use zig-overlay per project for a specific version
    python3
    pipx # python package manager
    # jdk17 # java 17
    nodejs # javascript
    pnpm # additional js package manager
    lua
    luarocks # lua package manager
    cmake
    just # command runner (like make)
    # qemu_full
    # love # lua 2D game engine (Balatro)
    # guile # GNU scheme (lisp)
    # janet # embeddable lisp that looks cool
  ];

  tools = with pkgs; [
    # astyle # C formatter
    checkbashisms # checks for bashisms in scripts
    shellcheck # there is also shellcheck-minimal in nixpkgs
    # perf # performance analysis tool (wrong package)
    hyperfine # benchmarking tool
    # poop # Performance Optimizer Observation Platform
    gdb # gnu debugger
    cloc # counts lines of code
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files
    # texliveMinimal # latex, see `texliveFull` too
    pandoc # document converter
  ];

  fs = with pkgs; [
    dosfstools
    mtools
    libisoburn # xorriso
    gptfdisk
    sshfs # mount drive over ssh
    ntfs3g # ntfs filesystem (windows compatibility)
    xfsprogs # xfs filesystem
    xfsdump # xfs snapshots
  ];

  archives = with pkgs; [
    bzip2
    gzip
    zip
    unzip
    p7zip
    xz
    zstd
    lz4
    ouch # Obvious Unified Compression Helper
  ];

  # Nix tools
  nix = with pkgs; [
    alejandra # formatter
    statix # linter
    deadnix # find and remove unused code in .nix source files
    nh # nix helper
    # comma
    # nix-output-monitor # replace `nix` with `nom`
    nurl
    self.pkgs.flint # flake linter
  ];
in [toolchains tools fs archives nix]
