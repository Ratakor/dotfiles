PREFIX = ${HOME}/.local
GITSITE = "https://git.ratakor.com"
ROOTCMD = $(shell command -v doas || command -v sudo)

all: packages configs scripts suckless mesofetch

packages:
	${ROOTCMD} pacman -Syu --noconfirm --needed $(shell grep -v '^#' .local/share/packages/packages)
	for package in $(shell grep -v '^#' .local/share/packages/packages.aur) ; do \
		git clone "https://aur.archlinux.org/$$package.git" ; \
		cd $$P && makepkg -si ; \
		cd .. && rm -rf $$P ; \
	done
	${ROOTCMD} pacman -Rns $(shell pacman -Qqdt)
	${ROOTCMD} ln -s /usr/bin/chromium /usr/local/bin/ungoogled-chromium
	${ROOTCMD} mandb

configs:
	mkdir -p ${PREFIX}/etc/
	cp -r .local/etc/* ${PREFIX}/etc/
	mkdir -p ${PREFIX}/share/
	cp -r .local/share/* ${PREFIX}/share/
	ln -s ${PREFIX}/etc/shell/zprofile ${HOME}/.zprofile
	ln -s ${PREFIX}/etc ${HOME}/.config # needed by the cringe joplin
	${ROOTCMD} patch /usr/bin/when ${PREFIX}/etc/when/patch

scripts:
	mkdir -p ${PREFIX}/bin/
	cp -r .local/bin/* ${PREFIX}/bin/

suckless:
	git clone ${GITSITE}/dwm.git ${PREFIX}/etc/dwm  && cd ${PREFIX}/etc/dwm && ${ROOTCMD} make install
	git clone ${GITSITE}/dwmblocks.git ${PREFIX}/etc/dwmblocks && cd ${PREFIX}/etc/dwmblocks && ${ROOTCMD} make install
	git clone ${GITSITE}/st.git ${PREFIX}/etc/st && cd ${PREFIX}/etc/st && ${ROOTCMD} make install
	git clone ${GITSITE}/dmenu.git ${PREFIX}/etc/dmenu && cd ${PREFIX}/etc/dmenu && ${ROOTCMD} make install
	git clone ${GITSITE}/slock.git ${PREFIX}/etc/slock && cd ${PREFIX}/etc/slock && ${ROOTCMD} make install

mesofetch:
	git clone ${GITSITE}/mesofetch.git /tmp/mesofetch
	cd /tmp/mesofetch && \
	cp example_config/small.h config.h && \
	${ROOTCMD} make install
	rm -rf /tmp/mesofetch
	mesofetch --recache
