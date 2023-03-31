PREFIX  = ${HOME}/.local
GITSITE = https://git.ratakor.com/
ROOTCMD = $(shell command -v doas || command -v sudo)

all: packages config scripts wallpapers clone install

packages:
	${ROOTCMD} pacman -Syu --noconfirm --needed $(shell grep -v '^#' .local/share/packages/packages)
	@echo Installing package from the AUR
	@.local/bin/aurinstall $(shell grep -v '^#' .local/share/packages/packages.aur)
	${ROOTCMD} mandb 2> /dev/null # Updating man database, it may take some time
	chsh -s /bin/zsh # cgabge your shell to zsh
	${ROOTCMD} ln -sfT /usr/bin/dash /usr/bin/sh # change sh from bash to dash

config:
	mkdir -p ${PREFIX}/etc
	cp -r .local/etc/* ${PREFIX}/etc/
	mkdir -p ${PREFIX}/share
	cp -r .local/share/* ${PREFIX}/share/
	su -c 'printf "export ZDOTDIR=\"\$$HOME/.local/etc/zsh\"" > /etc/zsh/zshenv'

scripts:
	mkdir -p ${PREFIX}/bin
	cp -r .local/bin/* ${PREFIX}/bin/

wallpapers:
	[ -d "${PREFIX}/share/wallpapers" ] &&\
		cd ${PREFIX}/share/wallpapers && git pull ||\
		git clone ${GITSITE}wallpapers.git ${PREFIX}/share/wallpapers

clone:
	mkdir -p ${PREFIX}/etc
	[ -d "${PREFIX}/etc/dwm" ] && cd ${PREFIX}/etc/dwm && git pull || git clone ${GITSITE}dwm.git ${PREFIX}/etc/dwm
	[ -d "${PREFIX}/etc/dwmblocks" ] && cd ${PREFIX}/etc/dwmblocks && git pull || git clone ${GITSITE}dwmblocks.git ${PREFIX}/etc/dwmblocks
	[ -d "${PREFIX}/etc/st" ] && cd ${PREFIX}/etc/st && git pull || git clone ${GITSITE}st.git ${PREFIX}/etc/st
	[ -d "${PREFIX}/etc/dmenu" ] && cd ${PREFIX}/etc/dmenu && git pull || git clone ${GITSITE}dmenu.git ${PREFIX}/etc/dmenu
	[ -d "${PREFIX}/etc/slock" ] && cd ${PREFIX}/etc/slock && git pull || git clone ${GITSITE}slock.git ${PREFIX}/etc/slock
	[ -d "${PREFIX}/etc/sic" ] && cd ${PREFIX}/etc/sic && git pull || git clone ${GITSITE}sic.git ${PREFIX}/etc/sic

install:
	${ROOTCMD} $(MAKE) -C ${PREFIX}/etc/slock PREFIX=${PREFIX} clean install # slock need to be owned by root
	$(MAKE) -C ${PREFIX}/etc/dwm PREFIX=${PREFIX} clean install
	$(MAKE) -C ${PREFIX}/etc/dwmblocks PREFIX=${PREFIX} clean install
	$(MAKE) -C ${PREFIX}/etc/st PREFIX=${PREFIX} TERMINFO=${PREFIX}/share/terminfo clean install
	$(MAKE) -C ${PREFIX}/etc/dmenu PREFIX=${PREFIX} clean install
	$(MAKE) -C ${PREFIX}/etc/sic PREFIX=${PREFIX} CFLAGS=-O2 clean install

anki:
	rm -rf anki-*
	curl -LO "https://github.com/ankitects/anki/releases/download/2.1.51/anki-2.1.51-linux-qt6.tar.zst"
	tar xf anki-*.tar.zst
	cd anki-*-linux-qt6 && sed -i 's/\/usr\//\$$HOME\/./' install.sh && ./install.sh
	rm -rf anki-*

lutris:
	${ROOTCMD} pacman -Syu --noconfirm --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader

.PHONY: all packages config scripts wallpapers clone install anki lutris
