# Cross platform shell prompt
{ config, ... }:
{
  hm.programs.oh-my-posh = {
    enable = config.hm.programs.nushell.enable;
    enableZshIntegration = false; # too slow & incorrect executiontime
    enableNushellIntegration = true;
    settings = {
      "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
      version = 4;
      final_space = true;
      blocks = [
        {
          type = "prompt";
          alignment = "left";
          segments = [
            {
              type = "status";
              style = "plain";
              foreground = "default";
              options = {
                always_enabled = true;
              };
              foreground_templates = [
                "{{ if .Error}}red{{ end }}"
              ];
              template = "<b>{{ .Code }}</b>";
            }
            {
              type = "executiontime";
              style = "plain";
              foreground = "blue";
              options = {
                always_enabled = true;
                style = "austin";
              };
              template = " <b>{{ .FormattedMs }}</b>";
            }
            {
              type = "path";
              style = "plain";
              foreground = "green";
              options = {
                style = "full"; # "unique"
              };
              template = " <b>{{ .Path }}</b>";
            }
            {
              type = "text";
              style = "plain";
              foreground = "default";
              template = " <b>%</b>";
            }
          ];
        }
        {
          type = "rprompt";
          alignment = "right";
          segments = [
            {
              type = "git";
              style = "plain";
              foreground = "#${config.self.colors.orange}"; # "yellow";
              options = {
                disable_with_jj = false; # TODO: https://ohmyposh.dev/docs/segments/scm/jujutsu
              };
              template = "{{ .HEAD }}"; # "({{ .Ref }})"
            }
          ];
        }
      ];
    };
  };
}
