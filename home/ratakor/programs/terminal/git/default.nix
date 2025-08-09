{
  config,
  pkgs,
  ...
}: {
  programs = {
    git = {
      enable = true;
      # package = pkgs.gitFull;
      lfs.enable = true;

      userName = "Ratakor";
      userEmail = "ratakor@disroot.org"; # ?
      signing = {
        key = "241B1CBE567B287E";
        format = "openpgp";
        # key = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
        # format = "ssh";
        signByDefault = true;
      };

      extraConfig = {
        init.defaultBranch = "master";
        color.ui = true;
        url = {
          "ssh://git@github.com" = {
            insteadOf = "https://github.com";
          };
          "ssh://git@ratakor.com" = {
            insteadOf = "https://git.ratakor.com";
          };
        };
        commit = {
          gpgsign = true;
          template = "${pkgs.writeText "commit" (builtins.readFile ./commit)}";
        };
        push.autoSetupRemote = true;
        core.sshCommand = "${pkgs.openssh_gssapi}/bin/ssh";
      };
    };

    gitui = {
      enable = true;
      # package = # use v0.22.1?
      keyConfig = ./key_bindings.ron;
      # theme = # default
    };
  };
}
