# Update PATH
PATH="$HOME/.local/bin:$PATH"
PATH="$PATH:$CARGO_HOME/bin"
PATH="$PATH:$GOPATH/bin"
export PATH

# Default programs
export EDITOR="editor"
export TERMINAL="st"
export BROWSER="browser"
export ROOTCMD="doas"
export MANPAGER="manpager"

# XDG directories
export XDG_CONFIG_HOME="$HOME/.local/etc"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.local/var/cache"
export XDG_STATE_HOME="$HOME/.local/var/state"
export XDG_DESKTOP_DIR="$HOME/tmp"
export XDG_DOCUMENTS_DIR="$HOME/tmp"
export XDG_DOWNLOAD_DIR="$HOME/tmp"
export XDG_PUBLICSHARE_DIR="$HOME/tmp"
export XDG_TEMPLATES_DIR="$HOME/tmp"
export XDG_MUSIC_DIR="$HOME/music"
export XDG_PICTURES_DIR="$HOME/pic"
export XDG_VIDEOS_DIR="$HOME/vid"

# ~/ Clean-up
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CARGO_TARGET_DIR="$XDG_CACHE_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export OPAMROOT="$XDG_DATA_HOME/opam"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npmrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export W3M_DIR="$XDG_STATE_HOME/w3m"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

# Misc
# umask 0077
export GPG_TTY=$(tty)
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export MANWIDTH=80
export LESS=-R
export HISTFILE="$XDG_DATA_HOME/histfile"
export HISTSIZE=10000
export SAVEHIST=10000
# export CC="tcc -L/usr/local/lib"
export CC="zig cc"
CC="$CC -Wall"
export LD_LIBRARY_PATH=/usr/local/lib
export LS_COLORS="di=1;34:ln=0;36:or=91:pi=0;33:bd=1;33:cd=1;33:so=1;31:ex=1;32:*.zig=38;5;214:*.pdf=38;5;62:*.o=38;5;94:*README=1;4;33:*README.txt=1;4;33:*README.md=1;4;33:*.ninja=1;4;33:*Makefile=1;4;33:*Cargo.toml=1;4;33:*CMakeLists.txt=1;4;33:*meson.build=1;4;33:*PKGBUILD=1;4;33:*Dockerfile=1;4;33:*.zip=0;31:*.tar=0;31:*.gz=0;31:*.bz2=0;31:*.a=0;31:*.ar=0;31:*.7z=0;31:*.iso=0;31:*.dmg=0;31:*.rar=0;31:*.tgz=0;31:*.xz=0;31:*.txz=0;31:*.lz=0;31:*.tlz=0;31:*.lzma=0;31:*.deb=0;31:*.rpm=0;31:*.zst=0;31:*.lz4=0;31:*.sig=0;37:*.bak=0;37:*.old=0;37:*.orig=0;37:*.part=0;37:*.rej=0;37:*.swp=0;37:*.tmp=0;37::*.jpg=38;5;70:*.jpeg=38;5;70:*.mjpg=38;5;70:*.gif=38;5;70:*.ico=38;5;70:*.bmp=38;5;70:*.pbm=38;5;70:*.pgm=38;5;70:*.ppm=38;5;70:*.tga=38;5;70:*.xbm=38;5;70:*.xpm=38;5;70:*.tif=38;5;70:*.tiff=38;5;70:*.png=38;5;70:*.svg=38;5;70:*.svgz=38;5;70:*.webp=38;5;70:*.mng=38;5;70:*.pcx=38;5;70:*.flc=38;5;70:*.fli=38;5;70:*.xcf=38;5;70:*.xwd=38;5;70:*.cgm=38;5;70:*.emf=38;5;70:*.ff=38;5;70:*.webm=38;5;25:*.ogm=38;5;25:*.mp4=38;5;25:*.m4v=38;5;25:*.mp4v=38;5;25:*.mkv=38;5;25:*.mpg=38;5;25:*.mpeg=38;5;25:*.avi=38;5;25:*.mov=38;5;25:*.wmv=38;5;25:*.flv=38;5;25:*.m2v=38;5;25:*.vob=38;5;25:*.qt=38;5;25:*.asf=38;5;25:*.rm=38;5;25:*.rmvb=38;5;25:*.ogv=38;5;25:*.ogx=38;5;25:*.mjpeg=38;5;25:*.aac=38;5;35:*.au=38;5;35:*.flac=38;5;35:*.m4a=38;5;35:*.mid=38;5;35:*.midi=38;5;35:*.mka=38;5;35:*.mp3=38;5;35:*.mpc=38;5;35:*.ogg=38;5;35:*.ra=38;5;35:*.wav=38;5;35:*.oga=38;5;35:*.opus=38;5;35:*.spx=38;5;35:*.xspf=38;5;35"
