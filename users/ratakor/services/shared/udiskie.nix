{
  # auto mount usb drives
  services.udiskie = {
    enable = false; # TODO: not configured yet
    automount = true;
    notify = true;

    settings = {
      program_options = {
        terminal = "footclient -D";
      };
    };
  };
}
