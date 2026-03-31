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
  };
}
