# USB device manager (auto-mounting)
{ config, ... }:
{
  hm.services.udiskie = {
    enable = false; # TODO: not configured yet
    automount = true;
    notify = true;

    settings = {
      program_options = {
        terminal = config.self.terminal.cmdDir;
      };
    };
  };
}
