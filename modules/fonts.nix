{
  pkgs,
  vega,
  ...
}: {
  fonts = {
    packages = with pkgs; [
      # Icon / emoji fonts
      material-design-icons
      noto-fonts-emoji-blob-bin
      noto-fonts-color-emoji
      # noto-fonts-monochrome-emoji

      # Normal fonts
      noto-fonts
      noto-fonts-cjk-sans
      vega.pkgs.luciole-fonts

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
      nerd-fonts.symbols-only # symbols icon only
      nerd-fonts.agave
    ];

    # Use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    # User defined fonts
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Blobmoji" "Noto Color Emoji"];
      sansSerif = ["Luciole" "Noto Sans" "Blobmoji" "Noto Color Emoji"];
      monospace = ["Agave Nerd Font Mono" "Blobmoji" "Noto Color Emoji"];
      emoji = ["Blobmoji" "Noto Color Emoji"];
    };
  };
}
