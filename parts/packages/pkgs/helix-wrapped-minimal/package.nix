{ pkgs, helix-wrapped }:
helix-wrapped.override {
  extraPackages = with pkgs; [
    # TODO: add *mandatory* language server and stuff here
  ];
}
