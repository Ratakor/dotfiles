{
  pkgs,
  ...
}: {
  wayland.windowManager = {
    river = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };

      # extraSessionVariables = {
      #   XDG_SESSION_TYPE = "wayland";
      #   XDG_CURRENT_DESKTOP = "river";
      # };

      # settings = {}; # TODO

      extraConfig = builtins.readFile ./init;
    };

    # TODO
    hyprland = {
      enable = false;
    };
  };
}
