{ pkgs, wrappers }:
wrappers.helix.override {
  theme = "acme";
  themeOverride = {
    "function" = {
      modifiers = [ "bold" ];
    };
  };
  extraPackages = with pkgs; [
    # Only add *mandatory* language servers and stuff here
  ];
}
