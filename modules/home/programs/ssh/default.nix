# SSH Client
{ pkgs, ... }:
{
  hm.programs.ssh = {
    enable = true;
    package = pkgs.openssh_gssapi; # use `null` for system default
    enableDefaultConfig = false; # deprecated
    settings = {
      "ssh.cri.epita.fr" = {
        GSSAPIAuthentication = "yes";
        GSSAPIDelegateCredentials = "yes";
      };
    };
  };
}
