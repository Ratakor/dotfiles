# file sync
{pkgs, ...}: {
  services.syncthing = {
    enable = false;
    # overrideDevices = false;
    # overrideFolders = false;
    # settings = {
    #   devices = {}; # TODO
    #   folders = {}; # TODO
    #   options = {}; # TODO
    # };
  };
}
