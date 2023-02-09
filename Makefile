PREFIX = ${HOME}/.local
GITSITE = "https://git.ratakor.com"
ROOTCMD = $(shell command -v doas || command -v sudo)

all: packages configs scripts suckless mesofetch

packages:
	${ROOTCMD} pacman -Syu --noconfirm --needed $(shell cat .local/share/packages/packages)
	for P in $(shell cat .local/share/packages/packages.aur) ; do \
		git clone "https://aur.archlinux.org/$$P.git" ; \
		cd $$P && makepkg -si ; \
		cd .. && rm -rf $$P ; \
	done
	${ROOTCMD} pacman -Rns $(shell pacman -Qqdt)
	${ROOTCMD} mandb

configs:
	mkdir -p ${PREFIX}/etc/
	cp -r .local/etc/* ${PREFIX}/etc/
	mkdir -p ${PREFIX}/share/
	cp -r .local/share/* ${PREFIX}/share/
	ln -s ${PREFIX}/etc/shell/zprofile ${HOME}/.zprofile
	${ROOTCMD} patch /usr/bin/when ${PREFIX}/etc/when/patch

scripts:
	mkdir -p ${PREFIX}/bin/
	cp -r .local/bin/* ${PREFIX}/bin/

suckless:
	git clone ${GITSITE}/dwm.git ${PREFIX}/share/dwm  && cd ${PREFIX}/share/dwm && ${ROOTCMD} make install
	git clone ${GITSITE}/dwmblocks.git ${PREFIX}/share/dwmblocks && cd ${PREFIX}/share/dwmblocks && ${ROOTCMD} make install
	git clone ${GITSITE}/st.git ${PREFIX}/share/st && cd ${PREFIX}/share/st && ${ROOTCMD} make install
	git clone ${GITSITE}/dmenu.git ${PREFIX}/share/dmenu && cd ${PREFIX}/share/dmenu && ${ROOTCMD} make install
	git clone ${GITSITE}/slock.git ${PREFIX}/share/slock && cd ${PREFIX}/share/slock && ${ROOTCMD} make install

mesofetch:
	git clone ${GITSITE}/mesofetch.git
	cp mesofetch/example_config/small.h mesofetch/config.h
	cd mesofetch && ${ROOTCMD} make install
	mesofetch --recache
	rm -rf mesofetch
