{ pkgs, helix-wrapped }:
helix-wrapped.override {
  theme = "acme";
  themeOverride = {
    "function" = {
      modifiers = [ "bold" ];
    };
  };
  extraPackages = with pkgs; [
    # Only add *mandatory* language servers and stuff here
    typescript-language-server # JavaScript
  ];
}
