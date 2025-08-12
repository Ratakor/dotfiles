{config, ...}: {
  programs = {
    # password manager (provides a cli version too)
    keepassxc = {
      enable = true;
      # TODO: weird
      # settings = {
      #   Browser.Enabled = true;

      #   GUI = {
      #     ApplicationTheme = "dark";
      #     # HidePasswords = true;
      #     # AdvancedSettings = true;
      #     # CompactMode = true;
      #   };

      #   Security = {
      #     ClearClipboardTimeout = 30;
      #   };
      # };
    };
  };
}
