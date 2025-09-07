# SSH Client
{pkgs, ...}: {
  hm.programs.ssh = {
    enable = true;
    package = pkgs.openssh_gssapi; # use `null` for system default
    enableDefaultConfig = false; # deprecated
    matchBlocks = {
      "ssh.cri.epita.fr" = {
        extraOptions = {
          GSSAPIAuthentication = "yes";
          GSSAPIDelegateCredentials = "yes";
        };
      };
    };
  };
}
