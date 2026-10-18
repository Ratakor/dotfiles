{ config, lib, ... }:
let
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.self.services.ollama;
in
{
  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      # inherit (cfg) package;
      home = mkDefault config.user.home;
      modelsDir = "${config.services.ollama.home}/.ollama/models";

      # declarative models...
      loadModels = [
        # "deepseek-coder-v2:16b"
        # "gpt-oss:20b"
      ];
      syncModels = false;
    };
  };
}
