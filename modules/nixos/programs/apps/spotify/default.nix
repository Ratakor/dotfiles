{
  config,
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf;

  spicetify = import sources.spicetify { inherit pkgs; };

  cfg = config.self.programs.apps.spotify;
in
{

  config = mkIf cfg.enable {
    self.programs.apps.spotify.package = config.hm.programs.spicetify.spotifyPackage;

    # user.packages = [
    #   pkgs.spotify
    #   pkgs.spicetify-cli
    # ];

    hm.imports = [
      spicetify.homeManagerModules.default
    ];

    hm.programs.spicetify = {
      enable = true;
      enabledCustomApps = with spicetify.packages.apps; [
        marketplace
        historyInSidebar
      ];
      enabledExtensions = with spicetify.packages.extensions; [
        adblockify
        hidePodcasts
        shuffle
      ];
      enabledSnippets = with spicetify.packages.snippets; [
        nyanCatProgressBar
        # spinningCdCoverArt
      ];

      theme = spicetify.packages.themes.default // {
        name = "marketplace";
      };

      # spicetify-nix doesn't work with declarative stuff
      # we need to use spotify from flatpak and do all the config imperatively
      # for theming to work with noctalia template
      # https://github.com/noctalia-dev/community-templates/tree/main/spicetify
      # https://spicetify.app/docs/getting-started#linux

      # theme = {
      #   name = "Colorful";
      #   # src = config.hm.lib.file.mkOutOfStoreSymlink "${config.hm.xdg.configHome}/spicetify/Themes/Colorful";
      #   # src = config.hm.lib.file.mkOutOfStoreSymlink "/home/ratakor/.config/spicetify/Themes/Colorful";
      #   src = pkgs.runCommandLocal "Colorful" { } ''
      #     mkdir -p $out
      #     ln -s "${config.hm.xdg.configHome}/spicetify/Themes/Colorful/color.ini" "$out/color.ini"
      #     cp "${./user.css}" "$out/user.css"
      #   '';
      # };
      # colorScheme = "noctalia";
    };
  };
}
