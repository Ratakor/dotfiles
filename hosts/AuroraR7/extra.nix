{ pkgs, ... }:
{
  hardware.nvidia = {
    branch = "legacy_580";
    open = false;
    powerManagement.enable = false;
  };

  services.ollama = {
    package = pkgs.ollama-cuda.override { cudaArches = [ "sm_61" ]; };
    home = "/storage/home";
  };
}
