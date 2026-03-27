# TODO: maybe remove graphical and instead use an option since it doesn't do much rn
{
  imports = [
    ./programs/dms.nix
    ./programs/wm.nix
    ./services/login.nix
    ./services/xserver.nix
  ];
}
