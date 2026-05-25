{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
in
{
  config = mkIf prg.editor.visual.zed.enable {
    self.programs.default.editor.visual = mkIf (prg.default.editor.visual.name == "zed") {
      inherit (config.hm.programs.zed-editor) package;
    };

    hm.programs.zed-editor = {
      enable = true;
      # TODO: config
    };
  };
}
