<h1 align="center">Ratakor's Parabola GNU/Linux-libre config</h1>

![screenshot](Pictures/normal.png)

## Installation
as if you just installed Parabola OpenRC, DO NOT TRY THIS if it's not a new install and you don't know what you're doing.
It will install my config as well as all packages I use except cli-visualizer, joplin, oneko and ungoogled-chromium.

	$ git clone https://github.com/ratakor/config.git
	$ cd config
	$ make

## Softwares

#### Graphical environment

- Window manager: [dwm](https://dwm.suckless.org)
- Compositor: [picom](https://github.com/yshui/picom), you can use [xcompmgr](https://github.com/freedesktop/xcompmgr) if you have performance issue
- Bar: [dwmblocks](https://github.com/torrinfail/dwmblocks)
- Swiss Army knife and Program launcher: [dmenu](https://tools.suckless.org/dmenu)
- Screen locker: [slock](https://tools.suckless.org/slock)

#### Command-line

- Shell: [zsh](https://github.com/zsh-users/zsh)
- Terminal emulator: [st](https://st.suckless.org/)
- Editor: [Neovim](https://github.com/neovim/neovim)

#### Web Browser

- [Ungoogled Chromium](https://github.com/ungoogled-software/ungoogled-chromium)
- Extensions
	- [uMatrix](https://github.com/gorhill/uMatrix)
	- [LibRedirect](https://libredirect.github.io)
	- [Vimium](https://github.com/philc/vimium)
	- [Dark Reader](https://darkreader.org)

#### Miscellaneous

- Font: [agave Nerd Font Complete Mono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Agave)
- File manager: [lf](https://github.com/gokcehan/lf)
- Document viewer: [zathura](https://github.com/pwmt/zathura)
- Video player: [mpv](https://github.com/mpv-player/mpv)
- Image viewer: [sxiv](https://github.com/xyb3rt/sxiv)
- Screenshot tool: [scrot](https://github.com/resurrecting-open-source-projects/scrot)
- Calendar: [when](https://github.com/bcrowell/when)
- Notes: [Joplin](https://joplinapp.org/terminal)
- RSS Reader: [Newsboat](https://newsboat.org/)

#### Software used but not worth mentionning

[yt-dlp](https://github.com/yt-dlp/yt-dlp), [tlp](https://linrunner.de/tlp), [redshift](https://github.com/jonls/redshift), [xbanish](https://github.com/jcs/xbanish), [cli-visualizer](https://github.com/dpayne/cli-visualizer), [neofetch](https://github.com/dylanaraps/neofetch), [mesofetch](https://github.com/ratakor/mesofetch), [exa](https://github.com/ogham/exa), [opendoas](https://man.openbsd.org/doas), man-db, xdo, htop, oneko, sx, pinta

## Scripts

- music: simple menu for selecting playlists
- dirsize: print the size of current directory or of a directory
- dmenu_websearch: websearch with dmenu
- manpdf: can be used as a shortcut with dwm to find man pages with dmenu or as "replacement" of man to view man pages as pdf. Require swallow, zathura and man-db (do "doas mandb" to fetch man pages info)
- off: simple dmenu interface for shutdown
- swallow (stolen from [swindles](https://git.cbps.xyz/swindlesmccoop/not-just-dotfiles/src/branch/master/.local/bin/swallow)): incredibly useful, requires xdo
- and other stuff :)

## TODO
- setup neomutt for mail
- swap mpv to mpd + mpc + ncmcpp for music
- add more font and a config.font file

![big_screen](Pictures/big_screen.png)
