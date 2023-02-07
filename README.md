<h1 align="center">Ratakor's Parabola GNU/Linux-libre config</h1>

![screenshot](Pictures/normal.png)

## Installation
As if you just installed Parabola OpenRC, DO NOT TRY THIS if it's not a new install and you don't know what you're doing.
It will install all my config, scripts and packages except joplin and ungoogled-chromium.

	$ git clone https://github.com/ratakor/config.git
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
- Shell: [zsh](https://github.com/zsh-users/zsh)
- Editor: [Neovim](https://github.com/neovim/neovim)
- File manager: [lf](https://github.com/gokcehan/lf)
- Document viewer: [zathura](https://github.com/pwmt/zathura)
- Video player: [mpv](https://github.com/mpv-player/mpv)
- Image viewer: [sxiv](https://github.com/xyb3rt/sxiv)
- Screenshot tool: [scrot](https://github.com/resurrecting-open-source-projects/scrot)
- Notes: [Joplin](https://joplinapp.org/terminal)
- Calendar: [when](https://github.com/bcrowell/when)
- RSS Reader: [Newsboat](https://newsboat.org/)

### Software used but not worth mentionning

[yt-dlp](https://github.com/yt-dlp/yt-dlp), [tlp](https://linrunner.de/tlp), [redshift](https://github.com/jonls/redshift), [xbanish](https://github.com/jcs/xbanish), [cli-visualizer](https://github.com/dpayne/cli-visualizer), [neofetch](https://github.com/dylanaraps/neofetch), [mesofetch](https://github.com/ratakor/mesofetch), [exa](https://github.com/ogham/exa), [opendoas](https://man.openbsd.org/doas), man-db, xdo, htop, oneko, sx, pinta

## TODO
- setup neomutt for mail
- swap mpv to mpd + mpc + ncmcpp for music
- fix issue with colored unicode characters not appearing
- add Ungoogled Chromium and VSCodium config (I don't use VSCodium yet)

![big_screen](Pictures/big_screen.png)
