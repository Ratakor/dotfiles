<h1 align="center">My dotfiles</h1>

![Screenshot River](.github/assets/screenshot_river.png)
(Outdated screenshot, my [parabola](https://github.com/ratakor/dotfiles/tree/parabola) config still look like that)

![Screenshot DWM](.github/assets/screenshot_dwm.png)
(Outdated screenshot, my [artix](https://github.com/ratakor/dotfiles/tree/artix) config still look like that)

## Software

### Graphical Environment
- Wayland Compositor: [Niri](https://github.com/YaLTeR/niri)
- Status Bar: [DMS](https://github.com/AvengeMedia/DankMaterialShell)
- Terminal Emulator: [Foot](https://codeberg.org/dnkl/foot)
- Launcher: [Fuzzel](https://codeberg.org/dnkl/fuzzel)
- Web Browser: [Ungoogled Chromium](https://github.com/ungoogled-software/ungoogled-chromium)
- Theme: [Gruvbox](https://github.com/morhetz/gruvbox)

### Command Line Interface
- Shell: [Zsh](https://github.com/zsh-users/zsh)
- Editor: [Helix](https://helix-editor.com/)
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
- Image Viewer: [imv](https://sr.ht/~exec64/imv)
- Notifications: [mako](https://github.com/emersion/mako)
- Mail Client: [Dove](https://dove.celenity.dev)
- Screen Locker: [swaylock](https://github.com/swaywm/swaylock)
- [Wallpapers](https://github.com/ratakor/wallpapers)

## Repo Structure

- [`flake`](flake): Individual parts of this flake.
  - [`apps`](flake/apps): Custom applications to be run with `nix run`.
  - [`lib`](flake/lib): Custom library of functions and utilities.
  - [`pkgs`](flake/pkgs): Custom packages and wrapped configurations.
  - [`templates`](flake/templates): Language specific templates for quickly initializing new projects.
  - [`fmt.nix`](flake/fmt.nix): Formatting configuration for `nix fmt` via [treefmt-nix](https://github.com/numtide/treefmt-nix).
  - [`keys.nix`](flake/keys.nix): My public SSH and PGP keys.
- [`hosts`](hosts): Per-host configurations.
- [`modules`](modules): Modularized configurations.
  - [`nixos`](modules/nixos): System & user configuration shared across all hosts.
  - [`options`](modules/options): Modules options for customizing my nixos config.
  - [`profiles`](modules/profiles): Shared configurations between similar machines.
- [`secrets`](secrets): Agenix secrets.

<!--
## Commit Convention

```git-commit
<scope>: <message>
```

### Scopes:

- `{path}`: Modification to a specific file or directory. Extension can be omitted if it makes sense.
- `hosts[/{host}]`: Modification to `hosts`.
- `[nixos/]{scope}`: Modification to `modules/nixos`.
- `options[/{option-group}]`: Modification to `modules/options`.
- `profiles[/{profile}]`: Modification to `modules/profiles`.
- `lib`: Modification to `flake/lib`.
- `packages[/{package}]`: Modification to `flake/pkgs[/packages]`.
- `wrappers[/{wrapper}]`: Modification to `flake/pkgs/wrappers`.
- `templates[/{template}]`: Modification to `flake/templates`.
-->

## Credits

- [NotAShelf/nyx](https://github.com/NotAShelf/nyx/)
- [foo-dogsquared/nixos-config](https://github.com/foo-dogsquared/nixos-config/)
- [viperML/dotfiles](https://github.com/viperML/dotfiles)
- [sioodmy/dotfiles](https://github.com/sioodmy/dotfiles)
- [fazzi/nixohess](https://gitlab.com/fazzi/nixohess)
- [diniamo/niqspkgs](https://github.com/diniamo/niqspkgs/)
- [ryan4yin/nixos-and-flakes](https://nixos-and-flakes.thiscute.world/)
