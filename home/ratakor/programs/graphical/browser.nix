{
  pkgs,
  config,
  username,
  ...
}: {
  # # ungoogled-chromium required to `pacman -Rdd your-freedom`
  # #aur/ungoogled-chromium-bin
  # #aur/ungoogled-chromium-xdg-bin # ungoogled chromium but without ~/.pki
  # aur/cromite-bin

  programs = {
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium; # TODO: cromite
      extensions = [
        {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # Vimium
        # TODO: add UBO, ...
      ];
    };

    firefox = {
      enable = false;
      # profiles.${username} = {};
    };

    # browser for lisp people
    nyxt = {
      enable = false;
    };

    # "minimal" vim-like browser
    qutebrowser = {
      enable = false;
    };
  };
}
