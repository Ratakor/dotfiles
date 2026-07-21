# Cross platform shell prompt
{ config, ... }:
{
  hm.programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
      version = 4;
      final_space = true;
      blocks = [
        {
          type = "prompt";
          alignment = "left";
          segments = [
            # https://ohmyposh.dev/docs/segments/system/status
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
            # https://ohmyposh.dev/docs/segments/system/executiontime
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
            # https://ohmyposh.dev/docs/segments/system/path
            {
              type = "path";
              style = "plain";
              foreground = "green";
              options = {
                style = "full"; # "unique"
              };
              template = " <b>{{ .Path }}</b>";
            }
            # https://ohmyposh.dev/docs/segments/system/text
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
            # https://ohmyposh.dev/docs/segments/scm/git
            {
              type = "git";
              style = "plain";
              foreground = "#${config.self.colors.default.orange}"; # "yellow";
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
