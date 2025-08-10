# menu for lock and shutdown
# TODO: requires glitchlock
{
  colors,
  pkgs,
  ...
}: let
  DMENU = "tofi --selection-color ${colors.red}";
  # DMENU = "dmenu -sb ${colors.red} -hf ${colors.cyan}";
in
  pkgs.writeShellApplication {
    name = "shutdown-menu";
    runtimeInputs = with pkgs; [tofi-dmenu river systemd];
    text = ''
      query=$(printf ' lock\n exit wm\n⏻ poweroff\n⏼ reboot' | ${DMENU} -i -p 'System')
      case $query in
      *"lock")
      	glitchlock ;;
      *"exit wm")
      	riverctl exit ;;
      *"poweroff")
      	poweroff ;;
      *"reboot")
      	reboot ;;
      esac
    '';
  }
