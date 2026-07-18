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
    # trash-cli # rm replacement (kinda), zfs/btrfs snapshots are way superior
    sd # sed replacement
    moor # less replacement
  ];

  hm.home.sessionVariables = {
    PAGER = "moor";
    MOOR = "-terminal-fg";
    LESS = "-R";
  };

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
    # grep = mkAlias "grep" [
    #   "--binary-files=without-match"
    #   "--color=auto"
    #   "--dereference-recursive"
    #   "--exclude-dir=.git"
    #   "--line-number"
    # ];
    ip = mkAlias "ip" [ "--color=auto" ];

    # ps = "procs";
    duf = mkAlias "duf" [
      "-hide special"
      "-hide-fs zfs"
    ];
    du = mkAlias "dust" [ "--reverse" ];
    # cat = mkAlias "bat" [
    #   # These are arguments for bat
    #   # I believe --decorations=auto is broken
    #   # "--style=numbers,changes"
    #   # "--tabs 8"
    # ];
    diff = mkAlias "riff" [ ];
    # less = mkAlias "moor" [ ];
    fd = mkAlias "fd" [
      # "--absolute-path" # print absolute paths
      # "--color=always" # always use colors
      "--exclude=.git/" # exclude .git directories
      # "--follow" # follow symlinks
      "--hidden" # show hidden files
      # "--no-ignore" # don't ignore files in .gitignore, .ignore, .fdignore, ...
      "--no-ignore-vcs" # don't ignore files in .gitignore
    ];

    sl = "ls";
    la = "ls -a";
    lr = "ls -R";
  };

  hm.programs = {
    zsh.shellAliases = {
      mkdir = mkAlias "mkdir" [
        "--parents"
        "--verbose"
      ];

      ls = mkAlias "eza" [
        # "--color=auto"
        "--group-directories-first"
        # "--hyperlink=auto"
      ];
      tree = "ls --tree";
      ll = "ls --long --group --header --octal-permissions --git";
    };

    nushell.shellAliases = {
      mkdir = mkAlias "mkdir" [ "--verbose" ];
      # TODO: replace ls with eza?
      ll = "ls -l";
    };

    # cat replacement
    bat = {
      enable = true;
      config = {
        inherit (config.self.colors.default.bat) theme;
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
      # Replaces cd & add `cdi` command.
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    # diff replacement
    # see also: delta
    riff = {
      enable = true;
      enableGitIntegration = true;
      commandLineOptions = [ ];
    };
  };
}
