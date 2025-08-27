{
  osConfig,
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
          path = osConfig.age.secrets.git-epita.path;
        }
      ];
    };

    # now idk if I prefer gitui v0.22.1 or the latest one
    # smh gitui is not building atm so let's keep v0.22.1
    gitui = {
      enable = true;
      # keyConfig = ./key_bindings.ron;
      # theme = # default

      package = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "gitui";
        version = "0.22.1";

        src = pkgs.fetchzip {
          url = "https://github.com/extrawurst/gitui/releases/download/v${finalAttrs.version}/gitui-linux-musl.tar.gz";
          hash = "sha256-a4u38ywgA3IB4Or3Cr5JCrUfF6R9cWQKEF/0hk9tLO8=";
        };

        installPhase = ''
          install -Dm755 gitui $out/bin/gitui
        '';

        inherit (pkgs.gitui) meta;
      });
      # package = pkgs.gitui.overrideAttrs (finalAttrs: prevAttrs: {
      #   name = "${prevAttrs.pname}-${finalAttrs.version}";
      #   version = "0.22.1";

      #   src = pkgs.fetchFromGitHub {
      #     owner = "extrawurst";
      #     repo = "gitui";
      #     rev = "v${finalAttrs.version}";
      #     hash = "sha256-K6xWTPu2a5NKYAYBt/sCWQOmuw9TCoKPA4ZxkoLWmeY=";
      #   };

      #   cargoDeps = prevAttrs.cargoDeps.overrideAttrs (const {
      #     name = "${finalAttrs.name}-vendor.tar.gz";
      #     inherit (finalAttrs) src;
      #     outputHash = "sha256-MZrx72poA6uOIulWIQkfOr9gy5qr5f61UtLITfES/rk=";
      #   });

      #   postPatch = "rm .cargo/config";
      # });
      keyConfig = ./key_bindings_0.22.1.ron;
      # theme = # default
    };
  };
}
