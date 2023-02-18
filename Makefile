PREFIX = ${HOME}/.local
GITSITE = https://git.ratakor.com/
ROOTCMD = $(shell command -v doas || command -v sudo)

all: packages configs scripts suckless mesofetch

packages:
	${ROOTCMD} pacman -Syu --noconfirm --needed $(shell grep -v '^#' .local/share/packages/packages)
	-${ROOTCMD} pacman -Rdd your-freedom
	@for package in $(shell grep -v '^#' .local/share/packages/packages.aur) ; do \
		.local/bin/aurinstall $$package ; \
	done
	mkdir -p ${PREFIX}/bin
	-ln -s /usr/bin/chromium ${PREFIX}/bin/ungoogled-chromium
	-${ROOTCMD} patch -N -r - /usr/bin/when .local/etc/when/patch
	${ROOTCMD} mandb &> /dev/null # This may take a few seconds
	chsh -s /bin/zsh # use your user password
	${ROOTCMD} ln -sfT /usr/bin/dash /usr/bin/sh # change sh from bash to dash

configs:
	mkdir -p ${PREFIX}/etc
	cp -r .local/etc/* ${PREFIX}/etc/
	mkdir -p ${PREFIX}/share
	cp -r .local/share/* ${PREFIX}/share/
	-ln -s ${PREFIX}/etc/shell/zprofile ${HOME}/.zprofile

scripts:
	mkdir -p ${PREFIX}/bin
	cp -r .local/bin/* ${PREFIX}/bin/

suckless:
	mkdir -p ${PREFIX}/bin/statusbar ${PREFIX}/etc
	-cp .local/bin/statusbar/* ${PREFIX}/bin/statusbar/
	[ -d "${PREFIX}/etc/dwm" ] && cd ${PREFIX}/etc/dwm && git pull || git clone ${GITSITE}dwm.git ${PREFIX}/etc/dwm
	[ -d "${PREFIX}/etc/dwmblocks" ] && cd ${PREFIX}/etc/dwmblocks && git pull || git clone ${GITSITE}dwmblocks.git ${PREFIX}/etc/dwmblocks
	[ -d "${PREFIX}/etc/st" ] && cd ${PREFIX}/etc/st && git pull || git clone ${GITSITE}st.git ${PREFIX}/etc/st
	[ -d "${PREFIX}/etc/dmenu" ] && cd ${PREFIX}/etc/dmenu && git pull || git clone ${GITSITE}dmenu.git ${PREFIX}/etc/dmenu
	[ -d "${PREFIX}/etc/slock" ] && cd ${PREFIX}/etc/slock && git pull || git clone ${GITSITE}slock.git ${PREFIX}/etc/slock
	cd ${PREFIX}/etc/dwm && make PREFIX=${PREFIX} clean install
	cd ${PREFIX}/etc/dwmblocks && make PREFIX=${PREFIX} clean install
	cd ${PREFIX}/etc/st && make PREFIX=${PREFIX} clean install
	cd ${PREFIX}/etc/dmenu && make PREFIX=${PREFIX} clean install
	cd ${PREFIX}/etc/slock && ${ROOTCMD} make PREFIX=${PREFIX} clean install # slock need to be owned by root

mesofetch:
	rm -rf /tmp/mesofetch
	git clone ${GITSITE}mesofetch.git /tmp/mesofetch
	cd /tmp/mesofetch && \
	cp example_config/small.h config.h && \
	make PREFIX=${PREFIX} install
	rm -rf /tmp/mesofetch
	-mesofetch --recache
