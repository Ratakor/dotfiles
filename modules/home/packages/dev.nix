{
  pkgs,
  self,
  ...
}:
let
  toolchains = with pkgs; [
    cargo # rust package manager
    rustc # rust compiler
    go # golang
    nasm # x86 compiler
    gcc # gnu compiler collection
    clang # another cc + clangd C lsp
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
    # guile # GNU scheme (lisp)
    # janet # embeddable lisp that looks cool
    # android-tools # adb, fastboot
    # wasmtime # WebAssembly runtime
    # dotnet-sdk # C#
    # R # R
  ];

  buildSystems = with pkgs; [
    # cmake
    gnumake
    just # command runner (like make)
    # go-task # yet another make alternative
  ];

  tools = with pkgs; [
    # astyle # C formatter
    checkbashisms # checks for bashisms in scripts
    shellcheck # there is also shellcheck-minimal in nixpkgs
    # perf # performance analysis tool (wrong package)
    hyperfine # benchmarking tool
    # poop # Performance Optimizer Observation Platform
    # gdb # gnu debugger
    cloc # counts lines of code
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files
    # texliveMinimal # latex, see `texliveFull` too
    pandoc # document converter
    # tinyxxd # hexdump utility, see `hexyl` too
    # teehee # modal terminal hex editor
    # self.pkgs.neocities-zig # TODO: not packaged
    # rustfmt # rust formatter
    zig-shell-completions
    moreutils # a lot of cool additional utils
    file # Program that shows the type of files
    findutils # find & xargs
    gawk # GNU implementation of the Awk programming language
    gnugrep # GNU implementation of the Unix grep command
    gnused # GNU sed, a batch stream editor
  ];

  # Some of these should probably be available system wide
  fs = with pkgs; [
    # lvm2
    cryptsetup
    dosfstools # FAT/VFAT filesystem
    # mtools # Utilities to access MS-DOS disks
    # libisoburn # xorriso
    gptfdisk
    sshfs # mount drive over ssh
    ntfs3g # ntfs filesystem (windows compatibility)
    # xfsprogs # xfs filesystem
    # xfsdump # xfs snapshots
    simple-mtpfs # mount phone easily
    btrfs-progs # btrfs filesystem
    # btrfs-snap # btrfs snapshot management tool
    # btrfs-list # `zfs list` for btrfs
    self.pkgs.zfs-restore # trash-restore but for ZFS snapshots
  ];

  archives = with pkgs; [
    ouch-rar # Obvious Unified Compression Helper
    # bzip2
    # gzip
    # zip
    # unzip
    # p7zip
    # xz
    # zstd
    # lz4
    # gnutar
  ];

  # Nix tools
  nix = with pkgs; [
    # nixfmt # formatter
    # statix # linter
    # deadnix # find and remove unused code in .nix source files
    nh # nix helper
    # nix-output-monitor # replace `nix` with `nom`
    nurl # Generate Nix fetcher calls from URLs
    self.pkgs.flint # flake linter
    # nix-tree # TUI viewer for nix derivations
    # nix-query-tree-viewer # GTK viewer for nix derivations
  ];

  idkProbablyUsefulTho = with pkgs; [
    pkgconf # Package compiler and linker metadata toolkit
    pkg-config # Tool that allows packages to find out information about other packages
    binutils # Tools for manipulating binaries (linker, assembler, etc.)
    groff # Luke Smith propaganda
    gnupatch # A program to apply differences to files
    texinfo # GNU documentation system
    which # Shows the full path of (shell) commands (builtin in zsh/nushell)
  ];
in
[
  toolchains
  buildSystems
  tools
  fs
  archives
  nix
  # idkProbablyUsefulTho
]
