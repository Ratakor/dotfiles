{
  pkgs,
  self,
  ...
}:
let
  dove = self.lib.flake.compat' self.pins.dove;
in
{
  imports = [ dove.nixosModules.default ];
  user.packages = [ pkgs.thunderbird ];

  # doesn't work the way I want it to work so we going full imperative (almost)
  hm.programs.thunderbird = {
    enable = false;
    # profiles.${config.self.username} = {
    #   isDefault = true;
    #   extensions = with pkgs; [
    #     external-editor-revived
    #   ];
    # };
  };
}
