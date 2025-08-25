# NOTE: I'm writing an alternative in zig at https://github.com/ratakor/zfs-restore
{
  lib,
  fetchFromGitHub,
  rustPlatform,
  zfs,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zfs-undelete";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "arctic-penguin";
    repo = "zfs-undelete";
    rev = "v${finalAttrs.version}";
    hash = "sha256-c3KcR9C9KCGTZkKP7OI3mFxYc7bC17dRJOF7RkquRno=";
  };

  cargoHash = "sha256-BZ/smgv+60r1QsvD7U+ngHLwCo73FM6P+vnDcB//KLs=";

  buildInputs = [
    zfs
  ];

  meta = {
    description = "An easy-to-use CLI tool to recover files from zfs snapshots";
    homepage = "https://github.com/arctic-penguin/zfs-undelete";
    licence = lib.licenses.gpl3Plus;
    maintainers = [];
    mainProgram = "zfs-undelete";
  };
})
