# Modern Shell
{ config, ... }:
{
  hm.programs = {
    nushell = {
      enable = false;
      # home-manager issue ig
      environmentVariables = config.hm.home.sessionVariables // {
        # prompt indicator handled by oh-my-posh
        PROMPT_INDICATOR = "";
        PROMPT_INDICATOR_VI_NORMAL = "";
        PROMPT_INDICATOR_VI_INSERT = "";
        PROMPT_MULTILINE_INDICATOR = "> ";
      };
      # see `config nu --doc`
      settings = {
        history = {
          file_format = "sqlite";
          # Basically disable sharing command history between nu sessions
          sync_on_enter = false; # plaintext only
          isolation = true; # sqlite only
        };
        show_banner = false; # "short" for startup time
        # rm.always_trash = true; # TODO: depends if filesystem snapshots are enabled
        edit_mode = "vi";
        cursor_shape = {
          vi_insert = "line";
          vi_normal = "block";
        };
      };
      plugins = [
        # TODO: All of belows are available in nixpkgs
        # https://github.com/FMotalleb/nu_plugin_desktop_notifications
        # https://github.com/JosephTLyons/nu_plugin_units
        # https://github.com/idanarye/nu_plugin_skim
        # https://github.com/cptpiepmatz/nu-plugin-highlight
      ];
    };

    # Autocompletion.
    # We use the superior fzf-tab on zsh, hence why carapace is setup here.
    carapace = {
      enable = config.hm.programs.nushell.enable;
      # ignoreCase = true;
      enableZshIntegration = false;
      enableNushellIntegration = true;
    };
  };
}
