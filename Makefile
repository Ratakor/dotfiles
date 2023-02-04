PREFIX = ${HOME}/.local
CONF = ${HOME}/.config
ROOTCOMMAND = $(shell command -v sudo || command -v doas)

all: packages configs scripts suckless xbanish vis doas joplin

packages:
	${ROOTCOMMAND} pacman -Syu --noconfirm $(cat .config/packages)
	${ROOTCOMMAND} mandb

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
	[ -d ${CONF}/suckless ] && SUCKLESS=${CONF}/suckless || SUCKLESS=".config/suckless"
	cd ${SUCKLESS}/dwm && ${ROOTCOMMAND} make clean install
	cd ${SUCKLESS}/dwmblocks && ${ROOTCOMMAND} make clean install
	cd ${SUCKLESS}/st && ${ROOTCOMMAND} make clean install
	cd ${SUCKLESS}/dmenu && ${ROOTCOMMAND} make clean install
	cd ${SUCKLESS}/slock && ${ROOTCOMMAND} make clean install

xbanish:
	git clone https://github.com/jcs/xbanish.git
	cd xbanish && ${ROOTCOMMAND} make install
	rm -rf xbanish

vis:
	${ROOTCOMMAND} pacman -Syu --noconfirm cmake fftw ncurses
	git clone https://github.com/dpayne/cli-visualizer.git
	cli-visualizer/install.sh
	rm -rf cli-visualizer

chromium: # doesn't work on parabola
	echo "kernel.unprivileged_userns_clone = 1" > /etc/sysctl.d/$(whoami).conf
	git clone https://aur.archlinux.org/ungoogled-chromium-bin.git
	cd ungoogled-chromium-bin && makepkg -si
	rm -rf ungoogled-chromium-bin
	ln -s /usr/bin/chromium /usr/local/bin/ungoogled-chromium

doas:
	echo "permit persist keepenv $(whoami)" >> /etc/doas.conf
	echo "permit nopass $(whoami) cmd poweroff" >> /etc/doas.conf
	echo "permit nopass $(whoami) cmd reboot" >> /etc/doas.conf

joplin:
	NPM_CONFIG_PREFIX=~/.joplin-bin npm install -g joplin
	${ROOTCOMMAND} ln -s ${HOME}/.joplin-bin/bin/joplin /usr/bin/joplin
