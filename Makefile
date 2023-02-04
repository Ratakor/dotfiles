PREFIX = ${HOME}/.local
CONF = ${HOME}/.config
ROOTCMD = $(shell command -v doas || command -v sudo)

all: packages configs scripts suckless xbanish mesofetch

packages:
	${ROOTCMD} pacman -Syu --noconfirm --needed $(shell cat .config/packages)
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

xbanish:
	git clone https://github.com/jcs/xbanish.git
	cd xbanish && ${ROOTCMD} make install
	rm -rf xbanish

mesofetch:
	git clone https://github.com/ratakor/mesofetch.git
	cp mesofetch/example_config/small.h mesofetch/config.h
	cd mesofetch && ${ROOTCMD} make install
	mesofetch --recache
	rm -rf mesofetch
