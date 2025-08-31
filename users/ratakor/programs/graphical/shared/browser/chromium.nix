{pkgs, ...}: {
  # See here for additional patches
  # https://github.com/noahvogt/chromium-patches
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium; # TODO: pkgs.cromite;
    dictionaries = with pkgs.hunspellDictsChromium; [en-us fr-fr];
    extensions = [
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # Vimium
      # {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
      # {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # uBlock Origin Lite
      # both ublock doesn't seem to work, is it time to switch to another browser?
    ];
    # See some hardening args here
    # https://github.com/Ratakor/dotfiles/blob/artix/.local/bin/browser
    # See celenityy/Titanium too
    # UC Flags needs to be configured for it to be as good as cromite
    commandLineArgs = []; # TODO
  };
}
