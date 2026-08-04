{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  inherit (config.hm.programs.zed-editor) package;

  prg = config.self.programs;
in
{
  config = mkIf prg.editor.zed.enable {
    self.programs.default.editor = mkIf (prg.default.editor.name == "zed") {
      inherit package;
    };

    hm.programs.zed-editor = {
      enable = true;
      # TODO: config
    };

    # This should be in shell.variables.nix, also here is previous comment:
    # We could instead set VISUAL to EDITOR if there is no visual editor
    # but editor is not visual, yes.
    # Also we're using meta.mainProgram instead of getExe for convenience.
    hm.home.sessionVariables.VISUAL = package.meta.mainProgram;
  };
}
