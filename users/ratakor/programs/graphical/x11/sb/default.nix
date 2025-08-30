# sb: statusbar
# A simple status bar for dwm
{self, ...}: {
  # home.packages = [self.pkgs.sb];
  xdg.configFile."sb/config".source = ./config;
}
# crontab btw
#*/30 * * * * kill -49 $(pidof sb); randwp
#0 0 * * * kill -48 $(pidof sb)

