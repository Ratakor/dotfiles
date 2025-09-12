# not including dwmblocks & scron
# make sure to add suid bit to slock
{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  xorg,
  ncurses,
  freetype,
  libxext,
  libxcrypt,
  imlib2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "suckless";
  version = "r4.771c89c";

  outputs = [
    "out"
    "man"
    "terminfo"
  ];

  src = fetchFromGitHub {
    owner = "ratakor";
    repo = "suckless";
    rev = "771c89ce144d90b4054058054209f09f73a81911";
    hash = "sha256-8PphWJ85jHU12cjgrFlD3lbKSEL5AQOo4kcolP4xGFY=";
  };

  nativeBuildInputs = [
    pkg-config
    ncurses
    fontconfig
    freetype
  ];

  buildInputs = [
    fontconfig
    xorg.libXinerama
    xorg.libX11
    xorg.libXft

    libxext
    libxcrypt
    imlib2
    xorg.libXrandr
    xorg.xorgproto
  ];

  patchPhase = ''
    sed -ri -e 's!\<(dmenu|dmenu_path)\>!'"$out/bin"'/&!g' dmenu/dmenu_run
    sed -ri -e 's!\<stest\>!'"$out/bin"'/&!g' dmenu/dmenu_path

    sed -i '/chmod u+s/d' slock/Makefile
  '';

  buildPhase = ''
    runHook preBuild

    make -C dmenu CC=$CC
    make -C dwm CC=$CC
    make -C sb CC=$CC
    make -C slock CC=$CC
    make -C st CC=$CC

    runHook postBuild
  '';

  # from st package.nix in nixpkgs
  preInstall = ''
    export TERMINFO=$terminfo/share/terminfo
    mkdir -p $TERMINFO $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  installPhase = ''
    runHook preInstall

    make -C dmenu PREFIX=$out install
    make -C dwm PREFIX=$out install
    make -C sb PREFIX=$out install
    make -C slock PREFIX=$out install
    make -C st PREFIX=$out install

    runHook postInstall
  '';

  meta = {
    description = "Ratakor's unmaintained suckless softwares";
    homepage = "https://github.com/ratakor/suckless";
    license = with lib.licenses; [
      mit
      isc
    ];
    maintainers = with lib.maintainers; [ ratakor ];
    platforms = lib.platforms.linux;
  };
})
