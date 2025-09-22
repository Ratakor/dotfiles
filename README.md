<h1 align="center">My dotfiles</h1>

![Screenshot River](.github/assets/screenshot_river.png)
(Outdated screenshot, my [parabola](https://github.com/ratakor/dotfiles/tree/parabola) config still look like that)

![Screenshot DWM](.github/assets/screenshot_dwm.png)
(Outdated screenshot, my [artix](https://github.com/ratakor/dotfiles/tree/artix) config still look like that)

## Softwares

### Graphical Environment
- Wayland Compositor: [Niri](https://github.com/YaLTeR/niri)
- Status Bar: [Waybar](https://github.com/Alexays/Waybar)
- Terminal Emulator: [Foot](https://codeberg.org/dnkl/foot)
- Launcher: [Fuzzel](https://codeberg.org/dnkl/fuzzel)
- Web Browser: [Ungoogled Chromium](https://github.com/ungoogled-software/ungoogled-chromium)
- Theme: [Gruvbox](https://github.com/morhetz/gruvbox)

### Command Line Interface
- Shell: [Zsh](https://github.com/zsh-users/zsh)
- Editor: [Helix](https://helix-editor.com/) / [Neovim](https://neovim.io/)
- Terminal Workspace: [Zellij](https://zellij.dev/)
- File Manager: [Yazi](https://github.com/sxyazi/yazi)
- Calendar: [Quand](https://github.com/ratakor/quand)
- RSS Reader: [Newsboat](https://newsboat.org/)
- IRC Client: [Senpai](https://sr.ht/~delthas/senpai/)

### Fonts
- Serif Font: [Noto Serif](https://fonts.google.com/noto/specimen/Noto+Serif)
- Sans-serif Font: [Luciole](https://luciole-vision.com)
- Monospace Font: [Agave Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Agave)
- Emoji Font: [Blobmoji](https://github.com/C1710/blobmoji)

### Miscellaneous
- Document Viewer: [zathura](https://github.com/pwmt/zathura)
- Video Player: [mpv](https://github.com/mpv-player/mpv)
<!-- - Music Player: [Music](.local/bin/music) -->
- Image Viewer: [imv](https://sr.ht/~exec64/imv)
- Notifications: [mako](https://github.com/emersion/mako)
<!-- - Screenshot Tool: [grim](https://sr.ht/~emersion/grim) -->
<!-- - Mail Client: [Claws Mail](https://www.claws-mail.org) -->
- Screen Locker: [swaylock](https://github.com/swaywm/swaylock)
- [Wallpapers](https://github.com/ratakor/wallpapers)

## Repo Structure

- [`flake.nix`](flake.nix): Entry point using nix flakes.
- [`hosts`](hosts): Per-host configurations.
- [`modules`](modules): Modularized configurations.
  - [`home`](modules/home): User configuration, this is probably what you want to look at.
  - [`nixos`](modules/nixos): System configuration shared across all hosts.
  - [`options`](modules/options): Modules options for customising my nixos config.
  - [`profiles`](modules/profiles): Shared configurations between similar machines.
- [`parts`](parts): Individual parts of this flake powered by [flake-parts](https://flake.parts/).
  - [`lib`](parts/lib): Custom library of functions and utilities.
  - [`npins`](parts/npins): Additional dependencies managed with [npins](https://github.com/andir/npins).
  - [`packages`](parts/packages): Custom pacakges and wrapped configurations.
  - [`shells`](parts/shells): Developpment shells for this flake and more if affinity.
  - [`templates`](parts/templates): Language specific templates for quickly initializing new projects.
  <!-- - [`args.nix`](parts/args.nix): Common arguments exposed by the flake. -->
  - [`fmt.nix`](parts/fmt.nix): Formating configuration for `nix fmt`.
  - [`keys.nix`](parts/keys.nix): My public SSH and PGP keys.
  - [`pre-commit`](parts/pre-commit.nix): Pre-commit hooks via [git-hooks.nix](https://github.com/cachix/git-hooks.nix).
- [`secrets`](secrets): Agenix secrets.

## Credits

- [NotAShelf/nyx](https://github.com/NotAShelf/nyx/)
- [foo-dogsquared/nixos-config](https://github.com/foo-dogsquared/nixos-config/)
- [viperML/dotfiles](https://github.com/viperML/dotfiles)
- [sioodmy/dotfiles](https://github.com/sioodmy/dotfiles)
- [fazzi/nixohess](https://gitlab.com/fazzi/nixohess)
- [diniamo/niqspkgs](https://github.com/diniamo/niqspkgs/)
- [ryan4yin/nixos-and-flakes](https://nixos-and-flakes.thiscute.world/)
