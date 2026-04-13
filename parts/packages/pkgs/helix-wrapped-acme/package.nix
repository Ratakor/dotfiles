{ pkgs, helix-wrapped }:
helix-wrapped.override {
  theme = "acme";
  extraPackages = with pkgs; [
    # TODO: add *mandatory* language server and stuff here
  ];
}
