# TODO: maybe remove graphical and instead use an option since it doesn't do much rn
{
  imports = [
    ./login.nix
    ./xserver.nix
  ];

  system.nixos.tags = ["graphical"];
}
