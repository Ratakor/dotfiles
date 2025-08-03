{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rustup # rust
    nasm # x86 compiler
    gcc # gnu compiler collection
    # clang # another cc + clangd C lsp (TODO: idk nixpkgs)
    tinycc # tiny c compiler
    # mingw-w64-gcc # windows cc (NOT IN NIX?)
    musl # another libc
    libbsd # Common functions found on BSD systems
    # zigup # TODO: use zig-overlay? (zigup not in nix repos)
    python3
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
    xfsprogs xfsdump # xfs filesystem
    # jdk17-openjdk # java (TODO: idk nixpkgs)
    poop # Performance Optimizer Observation Platform
    # TODO: vimPlugins.nvim-treesitter-parsers.superhtml?
    superhtml # html LSP
    # nodejs # javascript (TODO: idk nixpkgs)
    nodePackages.npm
    nodePackages.pnpm
    lua
    luarocks
    just # command runner (like make)
    cloc # counts lines of code

    ## archives
    zip
    xz
    unzip
    p7zip
    zstd
    lz4
    ouch # Obvious Unified Compression Helper
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
  };

  xdg.configFile.npmrc.text = ''
    prefix=${config.xdg.dataHome}/npm
    cache=${config.xdg.cacheHome}/npm
    init-module=${config.xdg.configHome}/npm/config/npm-init.js
  '';

  xdg.configFile."python/pythonrc".text = ''
    import readline
    readline.write_history_file = lambda *args: None
  '';
}
