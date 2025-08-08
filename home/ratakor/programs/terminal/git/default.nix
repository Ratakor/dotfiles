{
  config,
  mylib,
  pkgs,
  username,
  ...
}: {
  programs = {
    git = {
      enable = true;
      userName = mylib.capitalize username;
      userEmail = "ratakor@disroot.org"; # ?
      # signing.key = "241B1CBE567B287E";
      signing.key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub"; # need gpg.format = "ssh"
      lfs.enable = true;

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
        gpg.format = "ssh";
        push.autoSetupRemote = true;
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
