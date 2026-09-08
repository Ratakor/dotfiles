# TODO: for EDITOR and VISUAL sessionVariables we should maybe add `-w` flag
{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  inherit (config.hm.programs.zed-editor) package;

  prg = config.self.programs;
  isDefault = prg.default.editor.name == "zed";
in
{
  config = mkIf prg.editor.zed.enable {
    self.programs.default.editor = mkIf isDefault {
      inherit package;
    };

    hm.programs.zed-editor = {
      enable = true;
      # TODO: config...
      userSettings = {
        relative_line_numbers = "enabled";
        helix_mode = true;
        cursor_blink = false;
        session.trust_all_worktrees = true; # idk ig it's alright
        # TODO
        theme = {
          mode = "system";
          light = "Gruvbox Light";
          dark = "Gruvbox Dark";
        };
        wrap_guides = [
          80
          100
        ];
      };
    };

    # This should be in shell.variables.nix, also here is previous comment:
    # We could instead set VISUAL to EDITOR if there is no visual editor
    # but editor is not visual, yes.
    # Also we're using meta.mainProgram instead of getExe for convenience.
    hm.home.sessionVariables = mkIf isDefault {
      VISUAL = package.meta.mainProgram;
    };
  };
}
