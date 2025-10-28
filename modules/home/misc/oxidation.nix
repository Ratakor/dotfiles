# Replacement of various shell utilities.
# Most of them are bloated and written in rust hence oxidation.
{
  config,
  pkgs,
  ...
}:
let
  mkAlias = cmd: args: builtins.concatStringsSep " " ([ cmd ] ++ args);
in
{
  user.packages = with pkgs; [
    eza # ls & tree replacement
    fd # find replacement
    dust # du replacement
    duf # df replacement, see dysk too
    # procs # ps replacement
    socat # netcat replacement
    # trash-cli # rm replacement (kinda), -zfs/btrfs snapshots are way superior
  ];

  hm.home.shellAliases = {
    # previously "trash -v"
    rm = mkAlias "rm" [
      "--recursive"
      "--verbose"
    ];
    rmdir = mkAlias "rmdir" [
      # "--parents"
      "--verbose"
    ];
    mkdir = mkAlias "mkdir" [
      "--parents"
      "--verbose"
    ];
    cp = mkAlias "cp" [
      "--interactive"
      "--recursive"
      # "--reflink=always"
      "--verbose"
    ];
    mv = mkAlias "mv" [
      "--interactive"
      "--verbose"
    ];
    grep = mkAlias "grep" [
      "--binary-files=without-match"
      "--color=auto"
      "--dereference-recursive"
      "--exclude-dir=.git"
      "--line-number"
    ];
    diff = mkAlias "diff" [ "--color=auto" ];
    ip = mkAlias "ip" [ "--color=auto" ];
    less = mkAlias "less" [ "-R" ];

    # ps = "procs";
    duf = mkAlias "duf" [
      "-hide special"
      "-hide-fs zfs"
    ];
    du = mkAlias "dust" [ "--reverse" ];
    cat = mkAlias "bat" [
      # I believe --decorations=auto is broken
      # "--style=numbers,changes"
      # "--tabs 8"
    ];

    fd = mkAlias "fd" [
      # "--absolute-path" # print absolute paths
      # "--color=always" # always use colors
      "--exclude=.git/" # exclude .git directories
      # "--follow" # follow symlinks
      "--hidden" # show hidden files
      # "--no-ignore" # don't ignore files in .gitignore, .ignore, .fdignore, ...
      "--no-ignore-vcs" # don't ignore files in .gitignore
    ];

    ls = mkAlias "eza" [
      "--color=auto"
      "--group-directories-first"
      "--hyperlink"
    ];
    sl = "ls";
    la = "ls -a";
    laa = "ls -aa";
    lr = "ls --recurse";
    tree = "ls --tree";
    ll = "ls --long --group --header --octal-permissions --git";
    l = "ll -a";
  };

  hm.programs = {
    # cat replacement
    bat = {
      enable = true;
      config = {
        inherit (config.self.colors.bat) theme;
        style = "plain";
        tabs = "0";
      };
    };

    # grep replacement
    ripgrep = {
      enable = true;
      arguments = [
        # prevent rg from printing long lines & show a preview instead
        "--max-columns=100"
        "--max-columns-preview"

        # exclude .git files
        "--glob=!.git/*"
        # "--exclude=.git"

        "--follow" # follow symlinks
        "--hidden" # search hidden files
        "--smart-case" # case insensitive search if no uppercase letters are present
      ];
    };

    # TODO
    ripgrep-all = {
      enable = false;
    };

    # cd replacement
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
      enableZshIntegration = true; # replaces cd & add `cdi` command
    };
  };
}
