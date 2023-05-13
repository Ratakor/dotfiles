PREFIX  = ${HOME}/.local
GITSITE = https://git.ratakor.com/
ROOTCMD = $(shell command -v doas || command -v sudo)

all: packages config scripts wallpapers

packages:
	@printf '\033[34;1mAdd ratakor repository\033[m\n'
	@curl -s https://raw.githubusercontent.com/Ratakor/ratakor-repo/master/setup | ${ROOTCMD} sh
	@printf '\033[34;1mInstall all packages\033[m\n'
	@yes | LC_ALL=C ${ROOTCMD} pacman -Syu --needed $(shell grep -v '^#' share/packages/packages)
	@printf '\033[34;1mInstalling package from the AUR\n'
	@bin/aurinstall $(shell grep -v '^#' share/packages/packages.aur)
	@printf '\033[34;1mUpdate man database, it may take some time\033[m\n'
	@${ROOTCMD} mandb 2>/dev/null 1>&2
	@printf '\033[34;1mChange %s shell to zsh\033[m\n' "$$USER"
	@chsh -s /bin/zsh >/dev/null
	@printf '\033[34;1mChange ZDOTDIR to not have a symlink in $$HOME\033[m\n'
	@${ROOTCMD} sh -c 'printf "export ZDOTDIR=\"\$$HOME/.local/etc/zsh\"\n" > /etc/zsh/zshenv'

config:
	@printf '\033[34;1mCopy config to %s\033[m\n' "${PREFIX}/etc"
	@mkdir -p ${PREFIX}/etc
	@cp -r etc/* ${PREFIX}/etc/
	@# need to rebuild bat cache with bat cache --build (if using custom themes)
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
		git clone ${GITSITE}wallpapers.git ${PREFIX}/share/wallpapers

anki:
	rm -rf anki-*
	curl -LO "https://github.com/ankitects/anki/releases/download/2.1.51/anki-2.1.51-linux-qt6.tar.zst"
	tar xf anki-*.tar.zst
	cd anki-*-linux-qt6 && sed -i 's/\/usr\//\$$HOME\/./' install.sh && ./install.sh
	rm -rf anki-*

lutris:
	${ROOTCMD} pacman -Syu --noconfirm --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader

.PHONY: all packages config scripts wallpapers anki lutris
