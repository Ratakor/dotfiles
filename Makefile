PREFIX = ${HOME}/.local
CONF = ${HOME}/.config
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
	cp .zshrc ${HOME}/
	cp .zprofile ${HOME}/
	cp .aliasrc ${HOME}/
	mkdir -p ${PREFIX}/share/
	cp -r .local/share/* ${PREFIX}/share/
	ln -s ${CONF}/when ${HOME}/.when

scripts:
	mkdir -p ${PREFIX}/bin/
	cp -r .local/bin/* ${PREFIX}/bin/

suckless:
	cd .config/suckless/dwm && ${ROOTCMD} make clean install
	cd .config/suckless/dwmblocks && ${ROOTCMD} make clean install
	cd .config/suckless/st && ${ROOTCMD} make clean install
	cd .config/suckless/dmenu && ${ROOTCMD} make clean install
	cd .config/suckless/slock && ${ROOTCMD} make clean install

mesofetch:
	git clone https://github.com/ratakor/mesofetch.git
	cp mesofetch/example_config/small.h mesofetch/config.h
	cd mesofetch && ${ROOTCMD} make install
	mesofetch --recache
	rm -rf mesofetch
