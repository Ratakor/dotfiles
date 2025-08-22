{
  colors,
  pkgs,
  ...
}: {
  home.packages = [pkgs.libnotify];

  services.mako = {
    enable = true;
    settings = {
      width = 350;
      height = 400;
      border-size = 2;
      default-timeout = 5000;
      font = "monospace";
      max-icon-size = 32;
      #on-button-middle=exec makoctl menu -n "$id" "$MENU" -p "Select action:"

      # e6 is 0.9 alpha btw
      background-color = "#${colors.background}e6";
      text-color = "#${colors.foreground}ff";
      border-color = "#${colors.blue}ff";
    };
    extraConfig = ''
      [urgency=low]
      border-color=#${colors.green}ff

      [urgency=high]
      border-color=#${colors.red}ff
      default-timeout=0
    '';
  };
}
