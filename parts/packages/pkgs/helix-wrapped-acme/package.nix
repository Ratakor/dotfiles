{ pkgs, helix-wrapped }:
helix-wrapped.override {
  theme = "acme";
  themeOverride = {
    "function" = {
      modifiers = [ "bold" ];
    };
  };
  extraPackages = with pkgs; [
    # TODO: add *mandatory* language server and stuff here
  ];
}
