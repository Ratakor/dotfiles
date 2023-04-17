<h1 align="center">My dotfiles</h1>

![screenshot](https://ratakor.com/images/setup/waw.png)

## Installation
I follow the [.local convention](https://gist.github.com/Earnestly/84cf9670b7e11ae2eac6f753910efebe)
to a point that I have just one dotfile in $HOME (yes no .ssh, .dbus or .pki)
so you'll need to tweak the Makefile if you don't. Also if you're not using
Parabola OpenRC you will probably need to edit .local/share/packages according
to your distro.

DO NOT TRY TO INSTALL if it's not a fresh install and you don't know what you're doing.

	$ git clone https://git.ratakor.com/dotfiles.git
	$ cd dotfiles
	$ make

## Softwares

### Graphical environment

- Window manager: [dwm](https://git.ratakor.com/dwm.git)
- Compositor: [picom](https://github.com/yshui/picom)
- Bar: [dwmblocks](https://git.ratakor.com/dwmblocks.git)
- Terminal emulator: [st](https://git.ratakor.com/st.git)
- Program launcher: [dmenu](https://git.ratakor.com/dmenu.git)
- Screen locker: [slock](https://git.ratakor.com/slock.git)

### Fonts
- Serif font: [Noto Serif](https://fonts.google.com/noto/specimen/Noto+Serif)
- Sans-serif font: [Noto Sans](https://fonts.google.com/noto/specimen/Noto+Sans)
- Monospace font: [Agave Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Agave)
- Emoji font: [Noto Emoji](https://fonts.google.com/noto/specimen/Noto+Emoji)

### Miscellaneous

- Web Browser: [Ungoogled Chromium](https://github.com/ungoogled-software/ungoogled-chromium)
- Shell: [zsh](https://github.com/zsh-users/zsh)
- sh: [dash](http://gondor.apana.org.au/~herbert/dash/)
- Editor: [neovim](https://github.com/neovim/neovim)
- File manager: [lf](https://github.com/gokcehan/lf)
- Document viewer: [zathura](https://github.com/pwmt/zathura)
- Video player: [mpv](https://github.com/mpv-player/mpv)
- Music player: mpv with --input-ipc-server and some scripting to have it in dwmblocks
- Image viewer: [nsxiv](https://nsxiv.codeberg.page/)
- Screenshot tool: [maim](https://github.com/naelstrof/maim)
- Notes: markdown files
- Calendar: [quand](https://github.com/ratakor/quand)
- RSS reader: [newsboat](https://newsboat.org/)
- IRC client: [sic](https://tools.suckless.org/sic)
- Mail client: [Claws Mail](https://www.claws-mail.org)
- [Wallpapers](https://git.ratakor.com/wallpapers.git/)

See [packages](.local/share/packages) for a list and a small description of other programs I use.

## TODO
- make dwmblocks' blocks activation with a config file
- config or patch mtm to be usable

## LICENSE
Copyright © 2023 Ratakor <ratakor@disroot.org>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
