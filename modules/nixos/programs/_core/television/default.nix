{
  hm.programs = {
    television = {
      enable = true;
      # Add <C-T> for smart autocomplete & <C-R> for history search
      enableZshIntegration = true;
      channels = { };
      settings = { };
    };

    nix-search-tv = {
      enable = true;
      settings = {
        indexes = [
          "nixpkgs"
          "nixos"
          "home-manager"
          "noogle"
        ];
        update_interval = "24h";
      };
    };

    # I think we *need* to do that because of zsh-vi-mode.
    # Use mkAfter if it's still not working.
    zsh.initContent = /* zsh */ ''
      autoload -Uz add-zle-hook-widget

      _bindkey_television() {
        bindkey '^T' tv-smart-autocomplete
        bindkey '^R' tv-shell-history
      }

      add-zle-hook-widget zle-line-init _bindkey_television
    '';
  };
}
