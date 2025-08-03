{
  colors,
  ...
}: {
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

      # e6 is alpha btw
      background-color = "#${colors.background}e6";
      text-color = "#${colors.foreground}e6";
      border-color = "#${colors.cyan}e6";
    };
    extraConfig = ''
      [urgency=low]
      border-color=#${colors.green}e6

      [urgency=high]
      border-color=#${colors.red}e6
      default-timeout=0
    '';
  };
}
