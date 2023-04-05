PREFIX  = ${HOME}/.local
GITSITE = https://git.ratakor.com/
ROOTCMD = $(shell command -v doas || command -v sudo)

all: packages config scripts wallpapers clone

packages:
	@curl -sLO https://raw.githubusercontent.com/Ratakor/ratakor-repo/master/setup
	@chmod a+x setup
	${ROOTCMD} ./setup # add ratakor repository
	${ROOTCMD} pacman -Syu --noconfirm --needed $(shell grep -v '^#' .local/share/packages/packages)
	@echo Installing package from the AUR
	@.local/bin/aurinstall $(shell grep -v '^#' .local/share/packages/packages.aur)
	${ROOTCMD} mandb 2> /dev/null # Updating man database, it may take some time
	chsh -s /usr/bin/zsh # change your shell to zsh
	su -c 'printf "export ZDOTDIR=\"\$$HOME/.local/etc/zsh\"\n" > /etc/zsh/zshenv'

config:
	mkdir -p ${PREFIX}/etc
	cp -r .local/etc/* ${PREFIX}/etc/
	mkdir -p ${PREFIX}/share
	cp -r .local/share/* ${PREFIX}/share/

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

install:
	$(MAKE) -C ${PREFIX}/etc/dwm PREFIX=${PREFIX} clean install
	$(MAKE) -C ${PREFIX}/etc/dwmblocks PREFIX=${PREFIX} clean install

anki:
	rm -rf anki-*
	curl -LO "https://github.com/ankitects/anki/releases/download/2.1.51/anki-2.1.51-linux-qt6.tar.zst"
	tar xf anki-*.tar.zst
	cd anki-*-linux-qt6 && sed -i 's/\/usr\//\$$HOME\/./' install.sh && ./install.sh
	rm -rf anki-*

lutris:
	${ROOTCMD} pacman -Syu --noconfirm --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader

.PHONY: all packages config scripts wallpapers clone install anki lutris
