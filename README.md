<h1 align="center">Ratakor's Parabola GNU/Linux-libre config</h1>

![screenshot](Pictures/normal.png)

## Softwares

#### Graphical environment

- Window manager: [dwm](https://dwm.suckless.org)
- Compositor: [picom](https://github.com/yshui/picom), you can use [xcompmgr](https://github.com/freedesktop/xcompmgr) if you have performance issue
- Bar: [dwmblocks](https://github.com/torrinfail/dwmblocks)
- Swiss Army knife and Program launcher: [dmenu](https://tools.suckless.org/dmenu)
- Screen locker: [slock](https://tools.suckless.org/slock)

#### Command-line

- Shell: [Zsh](https://github.com/zsh-users/zsh)
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
- File manager: [ranger](https://github.com/ranger/ranger)
- Document viewer: [zathura](https://github.com/pwmt/zathura)
- Video player: [mpv](https://github.com/mpv-player/mpv)
- Image viewer: [sxiv](https://github.com/xyb3rt/sxiv)
- Screenshot tool: [scrot](https://github.com/resurrecting-open-source-projects/scrot)
- Calendar: [when](https://github.com/bcrowell/when)
- Notes: [Joplin](https://joplinapp.org/terminal)

#### Software used but not worth mentionning

[yt-dlp](https://github.com/yt-dlp/yt-dlp), [tlp](https://linrunner.de/tlp), [redshift](https://github.com/jonls/redshift), [xbanish](https://github.com/jcs/xbanish), [vis](https://github.com/dpayne/cli-visualizer), [neofetch](https://github.com/dylanaraps/neofetch), [mesofetch](https://github.com/ratakor/mesofetch), [exa](https://github.com/ogham/exa), [doas](https://man.openbsd.org/doas), man-db, xdo, newsboat

## Scripts

- cdmenu: cd + dmenu, slower but prettier
- dirsize: print the size of current directory or of a directory
- dmenu_websearch: websearch with dmenu
- manpdf: can be used as a shortcut with dwm to find man pages with dmenu or as "replacement" of man to view man pages as pdf. Require swallow, zathura and man-db (do "doas mandb" to fetch man pages info)
- off: simple dmenu interface for shutdown
- swallow (stolen from [swindles](https://git.cbps.xyz/swindlesmccoop/not-just-dotfiles/src/branch/master/.local/bin/swallow)): incredibly useful, requires xdo

## Installation
as if you just installed Arch or Parabola, DO NOT TRY THIS if it's not a new install and you don't know what you're doing

#### Dependencies

pacman -Sy these
- dwm : base-devel git xorg-xserver xorg-xinit libxinerama libx11 libxft webkit2gtk picom
- neovim and joplin: nodejs npm
- wallpaper: feh

#### Cloning

```
$ git clone https://github.com/ratakor/config.git
$ mv -i config/* $HOME
$ rmdir config
```

#### Building and installing

- dwm:
```
$ cd ~/.config/suckless/dwm
# make clean install
```
repeat for st, dmenu, slock and dwmblocks

![big_screen](Pictures/big_screen.png)
