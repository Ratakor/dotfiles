# Window Manager for Wayland
# kinda like dwm but without needing patches
# river mop when?
{
  config,
  lib,
  pkgs,
  ...
}@args:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.meta) getExe;

  RIVER_LOG_DIR = "${config.hm.xdg.stateHome}/river";
  prg = config.self.programs;
  dprg = prg.default;

  unwrappedRiver = pkgs.river-classic;

  wrapper = pkgs.writeShellScriptBin "river" ''
    timestamp=$(date +%Y-%m-%dT%H:%M:%S%z)
    mkdir -p "${RIVER_LOG_DIR}"

    # Run the raw river compositor directly in the login/PAM session
    ${unwrappedRiver}/bin/river -log-level warning > "${RIVER_LOG_DIR}/river-$timestamp.log" 2>&1
    exit_code=$?

    # Clean up systemd targets when the compositor exits
    systemctl --user stop river-session.target
    systemctl --user stop graphical-session.target

    exit $exit_code
  '';

  wrapperExe = getExe wrapper;

  riverWrapped =
    (pkgs.symlinkJoin {
      name = "river-wrapped-${lib.getVersion unwrappedRiver}";
      paths = [ unwrappedRiver ];
      postBuild = ''
        # Remove the original /bin/river symlink to prevent conflicts
        rm $out/bin/river
        # Copy our wrapper script to $out/bin/river
        cp ${wrapper}/bin/river $out/bin/river
      '';
    })
    // {
      override = unwrappedRiver.override;
      overrideAttrs = unwrappedRiver.overrideAttrs;
    };
in
{
  config = mkIf prg.windowManager.river-classic.enable {
    self.programs.default.windowManager = mkIf (dprg.windowManager.name == "river-classic") {
      cmd = wrapperExe;
      session = "river";
    };

    programs.river-classic = {
      enable = true;
      package = riverWrapped;
      xwayland.enable = true;
      extraPackages = mkForce [ ];
    };

    hm.xdg.configFile."river/init" = {
      text = import ./init.nix args;
      executable = true;
    };

    systemd.user.targets.river-session = {
      enable = true;
      description = "River compositor session";
      bindsTo = [ "graphical-session.target" ];
      wants = [
        "graphical-session-pre.target"
        "graphical-session.target"
      ];
      after = [ "graphical-session-pre.target" ];
    };
  };
}
