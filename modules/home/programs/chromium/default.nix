# Browser (duh)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
  cfg = prg.browser.chromium;
in
{
  config = mkIf cfg.enable {
    self.programs.default.browser = mkIf (prg.default.browser.name == "chromium") {
      inherit (cfg) package;
      newWindow = "chromium --new-window";
    };

    # See here for additional patches
    # https://github.com/noahvogt/chromium-patches
    hm.programs.chromium = {
      enable = true;
      inherit (cfg) package;
      dictionaries = with pkgs.hunspellDictsChromium; [
        en-us
        fr-fr
      ];
      extensions = [
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
        # {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
        # {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # uBlock Origin Lite
        # both ublock doesn't seem to work, is it time to switch to another browser?
      ];
      # See some hardening args here
      # https://github.com/Ratakor/dotfiles/blob/artix/.local/bin/browser
      # See celenityy/Titanium too
      # UC Flags needs to be configured for it to be as good as cromite
      commandLineArgs = [ ]; # TODO
    };
  };
}
