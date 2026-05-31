{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (lib.options)
    mkOption
    mkPackageOption
    mkEnableOption
    mkEnableOptions'
    literalExpression
    ;
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib) types;

  opt = options.self.programs;
  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    browser = recursiveUpdate (mkEnableOptions' opt.default.browser.name) {
      chromium = {
        package = mkPackageOption pkgs "chromium" {
          default = "helium";
          example = [ "ungoogled-chromium" ]; # see also cromite, github:celenityy/titanium
          extraDescription = ''
            The command used to launch a new browser may differ from "chromium".
          '';
        };

        drm.enable = mkEnableOption "DRM support for chromium" // {
          default = true;
        };

        dictionaries = mkOption {
          type = types.listOf types.package;
          default = with pkgs.hunspellDictsChromium; [
            en-us
            fr-fr
          ];
          defaultText = literalExpression ''
            with pkgs.hunspellDictsChromium; [
              en-us
              fr-fr
            ];
          '';
          description = "List of chromium dictionaries to install.";
        };

        # This doesn't seem to work well on ungoogled chromium or helium.
        extensions = mkOption {
          type = types.listOf (types.strMatching "[a-zA-Z]{32}");
          default = [
            # "ammjkodgmmoknidbanneddgankgfejfh" # 7TV
            # "fhlinfpmdlijegjlpgedcmglkakaghnk" # Better PathOfExile Trading
            # "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
            # "mjdepdfccjgcndkmemponafgioodelna" # DF Tube
            # "oboonakemofpalcgghocfoadofidjkkk" # KeePassXC
            # "oladmjdebphlnjjcnomfhhbfdldiimaf" # LibRedirect
            # "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
            # "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
            # "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
            # "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
            # "ndpmhjnlfkgfalaieeneneenijondgag" # YouTube Anti Translate
          ];
          example = literalExpression ''
            [
              "oboonakemofpalcgghocfoadofidjkkk" # KeePassXC
              "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
            ]
          '';
          description = ''
            List of chromium extensions to install.
            To find the extension ID, check its URL on the
            [Chrome Web Store](https://chrome.google.com/webstore/category/extensions).
          '';
        };
      };

      firefox = {
        package = mkPackageOption pkgs "firefox" {
          example = [ "librewolf" ]; # see also github:celenityy/phoenix
          extraDescription = ''
            The command used to launch a new browser may differ from "firefox".
          '';
        };
      };
    };

    default.browser = {
      name = mkOption {
        type = types.nullOr (
          types.enum [
            "chromium"
            "firefox"
            "nyxt"
            "qutebrowser"
            "tor-browser"
          ]
        );
        default = if sys.video.enable then "chromium" else null;
        defaultText = literalExpression ''
          if sys.video.enable then "chromium" else null;
        '';
        description = ''
          The default browser to use.
          This will automatically enable the corresponding program.
        '';
      };

      package =
        (mkPackageOption { } "default browser" {
          nullable = true;
          default = null;
        })
        // {
          internal = true;
        };

      newWindow = mkOption {
        type = types.str;
        description = "The command to spawn a new window.";
        # default = "dummy-browser --new-window";
        internal = true;
      };
    };
  };

  config.self.programs = mkIf (cfg.default.browser.name != null) {
    browser.${cfg.default.browser.name}.enable = true;
  };
}
