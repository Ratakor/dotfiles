PREFIX  = ${HOME}/.local
ROOTCMD = $(shell command -v doas || command -v sudo)

all: packages config scripts wallpapers

packages:
	@curl -sLO https://raw.githubusercontent.com/Ratakor/ratakor-repo/master/setup
	@chmod a+x setup
	${ROOTCMD} ./setup # add ratakor repository
	${ROOTCMD} pacman -Syu --noconfirm --needed $(shell sed 's/#.*//' .local/share/packages/packages)
	-${ROOTCMD} pacman -Rdd your-freedom
	@echo Installing package from the AUR
	@.local/bin/aurinstall $(shell sed 's/#.*//' .local/share/packages/packages.aur)
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
		git clone https://github.com/ratakor/wallpapers ${PREFIX}/share/wallpapers

anki:
	rm -rf anki-*
	curl -LO "https://github.com/ankitects/anki/releases/download/2.1.54/anki-2.1.54-linux-qt6.tar.zst"
	tar xf anki-*.tar.zst
	cd anki-*-linux-qt6 && sed -i 's/\/usr\//\$$HOME\/./' install.sh && ./install.sh
	rm -rf anki-*

.PHONY: all packages config scripts wallpapers clone install anki
