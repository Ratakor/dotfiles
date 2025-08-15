{
  config,
  pkgs,
  ...
}: {
  home.shellAliases = {
    G = "gitui";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gca = "git commit --all";
    gcv = "git commit --verbose";
    gcm = "git commit --message";
    gam = "git commit --amend";
    gp = "git push"; # --follow-tags"; # --tags
    gpl = "git pull";
    gr = "git restore";
    grs = "git restore --staged";
    gd = "git diff";
    gac = "ga . && gc";
    gacv = "ga . && gcv";
    gcp = "gc && gp";
    gacp = "ga . && gc && gp";
    gacpv = "ga . && gcv && gp";
  };

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

      delta = {
        enable = true;
        options = {}; # TODO
      };

      extraConfig = {
        init.defaultBranch = "master";
        color.ui = true;
        core.sshCommand = "${pkgs.openssh_gssapi}/bin/ssh";
        url = {
          "ssh://git@github.com/" = {
            pushInsteadOf = "https://github.com/";
          };
          "https://github.com/" = {
            insteadOf = "github:";
          };
          # "ssh://git@ratakor.com/" = {
          #   insteadOf = "https://git.ratakor.com/";
          # };
        };
        commit = {
          # verbose = true;
          template = "${pkgs.writeText "commit" (builtins.readFile ./commit)}";
        };
        # rebase = {
        #   autoSquash = true;
        #   autoStash = true;
        # };
        push = {
          # default = "simple";
          autoSetupRemote = true;
          followTags = true;
        };
        # branch.autoSetupRebase = "always";
        # rerere.enabled = true;
      };

      ignores = [
        "result"
        "result-*"
        ".direnv/"
      ];

      includes = [
        {
          condition = "hasconfig:remote.*.url:*epita.fr:**/**";
          path = "/run/agenix/git-epita";
        }
      ];
    };

    gitui = {
      enable = true;
      # package = # use v0.22.1?
      keyConfig = ./key_bindings.ron;
      # theme = # default
    };
  };
}
