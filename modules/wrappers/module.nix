{
  pkgs,
  self,
  ...
}: let
  wrapper-manager = import self.pins.wrapper-manager;

  wm-eval = wrapper-manager.lib {
    inherit pkgs;
    specialArgs = {inherit self;};
    modules = [
      ./modules
      ./home # TODO: move this out of here
    ];
  };
in {
  users.users.ratakor.packages = [wm-eval.config.build.toplevel];
  # environment.systemPackages = [wm-eval.config.build.toplevel];
}
