# Replacement of various shell utilities.
# Most of them are bloated and written in rust hence oxidation.
{
  config,
  pkgs,
  ...
}:
let
  mkAlias = cmd: args: cmd + " " + (builtins.concatStringsSep " " args);
in
{
  user.packages = with pkgs; [
    eza # ls & tree replacement
    fd # find replacement
    dust # du replacement
    duf # df replacement, see dysk too
    procs # ps replacement
    socat # netcat replacement
    # trash-cli # rm replacement (kinda) # TODO: no need for trash-cli if using zfs/btrfs snapshots
  ];

  hm.home.shellAliases = {
    rm = "rm -rv"; # "trash -v"
    rmdir = "rmdir -v"; # -p
    cp = "cp -riv"; # --reflink=always
    mv = "mv -iv";
    mkdir = "mkdir -pv";
    grep = "grep -RIn --exclude-dir=.git --color=auto";
    diff = "diff --color=auto";
    ip = "ip --color=auto";
    less = "less -R";
    # readlink = "readlink -f"; # use realpath instead

    ps = "procs";
    duf = "duf -hide special -hide-fs zfs";
    du = "dust --reverse";
    cat = "bat --style=numbers,changes --tabs 8";

    fd = mkAlias "fd" [
      # "--color=always" # always use colors
      "--hidden" # show hidden files
      # "--no-ignore" # don't ignore files in .gitignore, .ignore, .fdignore, ...
      "--no-ignore-vcs" # don't ignore files in .gitignore
      # "--absolute-path" # print absolute paths
      # "--follow" # follow symlinks
      "--exclude=.git/" # exclude .git directories
    ];

    ls = "eza --color=auto --group-directories-first --hyperlink";
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
