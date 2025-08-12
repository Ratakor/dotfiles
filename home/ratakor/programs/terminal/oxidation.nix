# replacement of various shell utilities
# most of them are bloated and written in rust hence oxidation
{
  colors,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [
      dust # du replacement
      duf # df replacement
      procs # ps replacement
      socat # netcat replacement
    ];

    # TODO: move other aliases here too
    shellAliases = {
      ps = "procs";
    };
  };

  programs = {
    # cat replacement
    bat = {
      enable = true;
      config = {
        inherit (colors.bat) theme;
        style = "plain";
        tabs = "0";
      };
    };

    # ls replacement
    eza = {
      enable = true;
      # TODO: config
    };

    # find replacement
    fd = {
      enable = true;
      # TODO: config
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
      options = ["--cmd cd"];
      enableZshIntegration = true; # replaces cd & add `cdi` command
    };
  };
}
