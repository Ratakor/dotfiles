PREFIX  = ${HOME}/.local
GITSITE = https://git.ratakor.com/
ROOTCMD = $(shell command -v doas || command -v sudo)

all: packages config scripts wallpapers clone install

packages:
	${ROOTCMD} pacman -Syu --noconfirm --needed $(shell grep -v '^#' .local/share/packages/packages)
	-${ROOTCMD} pacman -Rdd your-freedom
	@echo Installing package from the AUR
	@.local/bin/aurinstall $(shell grep -v '^#' .local/share/packages/packages.aur)
	${ROOTCMD} mandb 2> /dev/null # Updating man database, it may take some time
	chsh -s /bin/zsh # change your shell to zsh
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
	[ -d "${PREFIX}/etc/st" ] && cd ${PREFIX}/etc/st && git pull || git clone ${GITSITE}st.git ${PREFIX}/etc/st
	[ -d "${PREFIX}/etc/dmenu" ] && cd ${PREFIX}/etc/dmenu && git pull || git clone ${GITSITE}dmenu.git ${PREFIX}/etc/dmenu
	[ -d "${PREFIX}/etc/slock" ] && cd ${PREFIX}/etc/slock && git pull || git clone ${GITSITE}slock.git ${PREFIX}/etc/slock
	[ -d "${PREFIX}/etc/sic" ] && cd ${PREFIX}/etc/sic && git pull || git clone https://git.suckless.org/sic ${PREFIX}/etc/sic

install:
	${ROOTCMD} $(MAKE) -C ${PREFIX}/etc/slock clean install # slock need to be owned by root
	$(MAKE) -C ${PREFIX}/etc/dwm PREFIX=${PREFIX} clean install
	$(MAKE) -C ${PREFIX}/etc/dwmblocks PREFIX=${PREFIX} clean install
	$(MAKE) -C ${PREFIX}/etc/st PREFIX=${PREFIX} TERMINFO=${PREFIX}/share/terminfo clean install
	$(MAKE) -C ${PREFIX}/etc/dmenu PREFIX=${PREFIX} clean install
	$(MAKE) -C ${PREFIX}/etc/sic PREFIX=${PREFIX} CFLAGS=-O2 clean install

anki:
	rm -rf anki-*
	curl -LO "https://github.com/ankitects/anki/releases/download/2.1.54/anki-2.1.54-linux-qt6.tar.zst"
	tar xf anki-*.tar.zst
	cd anki-*-linux-qt6 && sed -i 's/\/usr\//\$$HOME\/./' install.sh && ./install.sh
	rm -rf anki-*

.PHONY: all packages config scripts wallpapers clone install anki
