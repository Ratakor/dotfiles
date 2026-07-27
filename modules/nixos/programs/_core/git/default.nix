# VCS
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  user.packages = with pkgs; [
    wrappers.gitui
    pre-commit
    gist # github gist
    act # local github actions
  ];

  hm.programs.lazygit = {
    enable = false; # currently using gitui
  };

  # idk idk idk
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
  };

  hm.programs.git = {
    enable = true;
    # package = pkgs.gitFull;
    lfs.enable = true;

    signing = {
      key = "241B1CBE567B287E";
      format = "openpgp";
      # key = "${config.hm.home.homeDirectory}/.ssh/id_rsa.pub";
      # format = "ssh";
      signByDefault = true;
    };

    settings = {
      user = {
        name = config.self.user.fullName;
        inherit (config.self.user) email;
      };
      alias = {
        st = "status";
        ci = "commit -s";
        cim = "commit -s -m";
        desc = "describe";
        ls = "ls-files";
        rename = "commit --amend -s -m";
      };
      init.defaultBranch = "master";
      color.ui = true;
      core.sshCommand = "${pkgs.openssh_gssapi}/bin/ssh";
      url = {
        "ssh://git@github.com/" = {
          insteadOf = [
            "https://github.com/"
            "github:"
          ];
        };
        "ssh://git@gitlab.com/" = {
          insteadOf = [
            "https://gitlab.com/"
            "gitlab:"
          ];
        };
        "ssh://git@git.sr.ht.com/" = {
          insteadOf = [
            "https://git.sr.ht.com/"
            "srht:" # "sourcehut:"
          ];
        };
        "ssh://git@codeberg.org/" = {
          insteadOf = [
            "https://codeberg.org/"
            "codeberg:"
          ];
        };
        # "ssh://git@ratakor.com/" = {
        #   insteadOf = "https://git.ratakor.com/";
        # };
      };
      commit = {
        # verbose = true;
        template = "${./commit}";
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
      (mkIf (config.age.secrets ? git-epita) {
        condition = "hasconfig:remote.*.url:*epita.fr:**/**";
        path = config.age.secrets.git-epita.path;
      })
    ];
  };

  hm.home.shellAliases = {
    G = "gitui";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gca = "git commit --all";
    gcv = "git commit --verbose";
    gcm = "git commit --message";
    gam = "git commit --amend";
    gp = "git push"; # --follow-tags"; # --tags
    gpf = "git push --force-with-lease";
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
}
