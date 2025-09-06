{
  pkgs,
  self,
  ...
}: let
  wrapper-manager = import self.pins.wrapper-manager;

  wm-eval = wrapper-manager.lib.eval {
    inherit pkgs;
    # specialArgs = {wrapLib = self.lib;};
    specialArgs = {inherit self;};
    modules = [
      ./modules
      ./home # TODO: move this out of here
    ];
  };
in {
  # zellij = wm-eval.config.wrappers.zellij.wrapped;
  # allWrapers = wm-eval.config.build.packages;

  users.users.ratakor.packages = [wm-eval.config.build.toplevel];
  # environment.systemPackages = [wm-eval.config.build.toplevel];
}
