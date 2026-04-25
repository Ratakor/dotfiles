{
  pkgs,
  self,
  sources,
  ...
}:
let
  dove = self.lib.flakes.compat' sources.dove;
in
{
  imports = [ dove.nixosModules.default ];
  user.packages = [ pkgs.thunderbird ];

  # doesn't work the way I want it to work so we going full imperative (almost)
  hm.programs.thunderbird = {
    enable = false;
    # profiles.${config.self.user.name} = {
    #   isDefault = true;
    #   extensions = with pkgs; [
    #     external-editor-revived
    #   ];
    # };
  };
}
