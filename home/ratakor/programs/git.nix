{
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Ratakor";
    userEmail = "ratakor@disroot.org";
  };
}
