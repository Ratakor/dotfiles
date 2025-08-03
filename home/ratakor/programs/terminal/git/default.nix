{
  username,
  pkgs,
  ...
}: {
  programs = {
    git = {
      enable = true;
      userName = "Ratakor"; # TODO: capitalize username
      userEmail = "ratakor@disroot.org"; # ?
      # TODO: other config
    };

    gitui = {
      enable = true;
      # package = # use v0.22.1?
      keyConfig = ./key_bindings.ron;
      # theme = # default
    };
  };
}
