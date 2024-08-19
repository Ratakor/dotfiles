PREFIX  = ${HOME}/.local
ROOTCMD = $(shell command -v doas || command -v sudo)

all: packages config scripts wallpapers

packages:
	@printf '\033[34;1mInstall all packages\033[m\n'
	@yes | LC_ALL=C ${ROOTCMD} pacman -Syu --needed $(shell sed -e 's/#.*//' -e 's/aur\/.*//' share/packages)
	@printf '\033[34;1mInstall packages from the AUR\033[m\n'
	@bin/aurinstall $(shell grep '^aur/' share/packages | sed -e 's/#.*//' -e 's/aur\///')
	@printf '\033[34;1mInstall custom packages\033[m\n'
	@for pkg in share/pkgbuilds/*; do\
		(cd "$$pkg" && makepkg -si --noconfirm);\
	done

config:
	@printf '\033[34;1mChange %s shell to zsh\033[m\n' "$$USER"
	@chsh -s /bin/zsh >/dev/null
	@printf '\033[34;1mChange ZDOTDIR to not have a symlink in $$HOME\033[m\n'
	@${ROOTCMD} sh -c 'printf "export ZDOTDIR=\"\$$HOME/.local/etc/zsh\"\n" > /etc/zsh/zshenv'
	@printf '\033[34;1mCopy config to %s\033[m\n' "${PREFIX}/etc"
	@mkdir -p ${PREFIX}/etc
	@cp -r etc/* ${PREFIX}/etc/
	@printf '\033[34;1mCopy data to %s\033[m\n' "${PREFIX}/share"
	@mkdir -p ${PREFIX}/share
	@cp -r share/* ${PREFIX}/share/

scripts:
	@printf '\033[34;1mCopy scripts to %s\033[m\n' "${PREFIX}/bin"
	@mkdir -p ${PREFIX}/bin
	@cp -r bin/* ${PREFIX}/bin/

wallpapers:
	@printf '\033[34;1mDownloading wallpapers\033[m\n'
	@[ -d "${PREFIX}/share/wallpapers" ] &&\
		printf '\033[33;1mWallpaper folder already exists\033[m\n'||\
		git clone https://github.com/ratakor/wallpapers ${PREFIX}/share/wallpapers

.PHONY: all packages config scripts wallpapers
