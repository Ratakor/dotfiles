PREFIX = ${HOME}/.local
CONF = ${HOME}/.config
GITSITE = "https://git.ratakor.com/"
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
	mkdir -p ${CONF}
	cp -r .config/* ${CONF}/
	mkdir -p ${PREFIX}/share/
	cp -r .local/share/* ${PREFIX}/share/
	ln -s ${CONF}/shell/zprofile ${HOME}/.zprofile
	${ROOTCMD} patch /usr/bin/when ${CONF}/when/patch

scripts:
	mkdir -p ${PREFIX}/bin/
	cp -r .local/bin/* ${PREFIX}/bin/

suckless:
	git clone ${GITSITE}/dwm.git && cd dwm && ${ROOTCMD} make clean install
	git clone ${GITSITE}/dwmblocks.git && cd dwmblocks && ${ROOTCMD} make clean install
	git clone ${GITSITE}/st.git && cd st && ${ROOTCMD} make clean install
	git clone ${GITSITE}/dmenu.git && cd dmenu && ${ROOTCMD} make clean install
	git clone ${GITSITE}/slock.git && cd slock && ${ROOTCMD} make clean install
	#rm -rf dwm dwmblocks st dmenu slock

mesofetch:
	git clone ${GITSITE}/mesofetch.git
	cp mesofetch/example_config/small.h mesofetch/config.h
	cd mesofetch && ${ROOTCMD} make install
	mesofetch --recache
	rm -rf mesofetch
