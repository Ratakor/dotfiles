# file sync
# TODO + this shouldn't be in terminal imo
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
