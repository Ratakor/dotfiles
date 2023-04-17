# Update PATH
PATH="$HOME/.local/bin:$PATH"
PATH="$PATH:$XDG_DATA_HOME/cargo/bin"
PATH="$PATH:$XDG_DATA_HOME/dotnet/.dotnet/tools"
export PATH

# Default programs
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="browser"
export ROOTCMD="doas"
export MANPAGER="sh -c 'col -bx | bat --paging=auto -l man -p'"

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

# Misc
umask 0077
export GPG_TTY=$(tty)
export DOTNET_CLI_TELEMETRY_OPTOUT="true"
export MANWIDTH=80
HISTFILE="$XDG_DATA_HOME/histfile"
HISTSIZE=10000
SAVEHIST=10000
#export LS_COLORS="di=1;34:ln=0;36:pi=0;33:bd=1;33:cd=1;33:so=1;31:ex=1;32:*README=1;33:*README.txt=1;33:*README.md=1;33:*readme.txt=1;33:*readme.md=1;33:*.ninja=1;33:*Makefile=1;33:*Cargo.toml=1;33:*SConstruct=1;33:*CMakeLists.txt=1;33:*build.gradle=1;33:*pom.xml=1;33:*Rakefile=1;33:*package.json=1;33:*Gruntfile.js=1;33:*Gruntfile.coffee=1;33:*BUILD=1;33:*BUILD.bazel=1;33:*WORKSPACE=1;33:*build.xml=1;33:*Podfile=1;33:*webpack.config.js=1;33:*meson.build=1;33:*composer.json=1;33:*RoboFile.php=1;33:*PKGBUILD=1;33:*Justfile=1;33:*Procfile=1;33:*Dockerfile=1;33:*Containerfile=1;33:*Vagrantfile=1;33:*Brewfile=1;33:*Gemfile=1;33:*Pipfile=1;33:*build.sbt=1;33:*mix.exs=1;33:*bsconfig.json=1;33:*tsconfig.json=1;33:*.zip=0;31:*.tar=0;31:*.Z=0;31:*.z=0;31:*.gz=0;31:*.bz2=0;31:*.a=0;31:*.ar=0;31:*.7z=0;31:*.iso=0;31:*.dmg=0;31:*.tc=0;31:*.rar=0;31:*.par=0;31:*.tgz=0;31:*.xz=0;31:*.txz=0;31:*.lz=0;31:*.tlz=0;31:*.lzma=0;31:*.deb=0;31:*.rpm=0;31:*.zst=0;31:*.lz4=0;31"
