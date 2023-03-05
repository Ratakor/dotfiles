<h1 align="center">My dotfiles</h1>

![screenshot](/pictures/normal.png)

## Installation
I follow the [.local convention](https://gist.github.com/Earnestly/84cf9670b7e11ae2eac6f753910efebe) so be sure that PREFIX is setup the way you like. Also if you're not using Parabola OpenRC you will probably need to edit .local/share/packages/packages according to your distro.

DO NOT TRY TO INSTALL if it's not a fresh install and you don't know what you're doing.

	$ git clone https://git.ratakor.com/dotfiles.git
	$ cd config
	$ make

## Softwares

### Graphical environment

- Window manager: [dwm](https://dwm.suckless.org)
- Compositor: [picom](https://github.com/yshui/picom), use [xcompmgr](https://github.com/freedesktop/xcompmgr) if you experience performance issues
- Bar: [dwmblocks](https://github.com/torrinfail/dwmblocks)
- Terminal emulator: [st](https://st.suckless.org/)
- Program launcher: [dmenu](https://tools.suckless.org/dmenu)
- Screen locker: [slock](https://tools.suckless.org/slock)

### Fonts
- Serif font: [Noto Serif](https://fonts.google.com/noto/specimen/Noto+Serif)
- Sans-serif font: [Noto Sans](https://fonts.google.com/noto/specimen/Noto+Sans)
- Monospace font: [Agave Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Agave)
- Emoji font: [Noto Emoji](https://fonts.google.com/noto/specimen/Noto+Emoji)

### Miscellaneous

- Web Browser: [Ungoogled Chromium](https://github.com/ungoogled-software/ungoogled-chromium)
- User Shell: [zsh](https://github.com/zsh-users/zsh)
- Shell: [dash](http://gondor.apana.org.au/~herbert/dash/)
- Editor: [neovim](https://github.com/neovim/neovim)
- File manager: [lf](https://github.com/gokcehan/lf)
- Document viewer: [zathura](https://github.com/pwmt/zathura)
- Video player: [mpv](https://github.com/mpv-player/mpv)
- Music player: mpv with --input-ipc-server and some scripting to have it in dwmblocks
- Image viewer: [sxiv](https://github.com/xyb3rt/sxiv)
- Screenshot tool: [maim](https://github.com/naelstrof/maim)
- Notes: markdown files
- Calendar: [when](https://github.com/bcrowell/when)
- RSS Reader: [newsboat](https://newsboat.org/)

See [packages](.local/share/packages/packages) and [AUR](.local/share/packages/packages.aur) for a list of other programs I use.

## TODO
- setup neomutt for mail
- add Ungoogled Chromium config
- add DAP for debugging in nvim
