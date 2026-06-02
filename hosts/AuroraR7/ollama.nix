# This will get a proper option and everything once it works with this host
{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda.override {
      cudaArches = [ "sm_61" ];
    };
    home = "/storage/home/.ollama"; # see also models

    # declarative models...
    loadModels = [
      # "deepseek-coder-v2:16b"
      # "gpt-oss:20b"
    ];
    syncModels = false;
  };
}
