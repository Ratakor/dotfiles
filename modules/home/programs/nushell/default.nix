# Modern Shell
{ config, ... }:
{
  hm.programs = {
    nushell = {
      enable = false;
      # home-manager issue ig
      environmentVariables = config.hm.home.sessionVariables;
      settings = {
        show_banner = false;
        edit_mode = "vi";
        # TODO: setup the rest
      };
      plugins = [
        # All of belows are available in nixpkgs
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
