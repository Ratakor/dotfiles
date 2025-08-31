{pkgs, ...}: {
  programs = {
    # See some hardening args here
    # https://github.com/Ratakor/dotfiles/blob/artix/.local/bin/browser
    # See here for additional patches
    # https://github.com/noahvogt/chromium-patches
    # UC Flags needs to be configured for it to be as good as cromite
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium; # TODO: pkgs.cromite;
      dictionaries = with pkgs.hunspellDictsChromium; [ en-us fr-fr ];
      extensions = [
        {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # Vimium
        # {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
        {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # uBlock Origin Lite
        # is it time to switch to another browser?
      ];
      commandLineArgs = []; # TODO
    };

    # check out celenityy/phoenix
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
