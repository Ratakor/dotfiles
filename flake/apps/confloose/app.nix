# nix run github:ratakor/dotfiles#confloose  >> ~/.bashrc
{ lib, pkgs }:
let
  inherit (lib.strings) concatMapStringsSep;

  mkAliases = aliases: cmd: concatMapStringsSep "\n" (alias: "alias '${alias}'='${cmd}'") aliases;

  # These "aliases" can't be cancelled by prefixing the command with '\'
  mkFuncAliases = aliases: cmd: concatMapStringsSep "\n" (alias: "${alias}() { ${cmd}; }") aliases;

  editors = [
    # "ed" # ed is the standard text editor
    "vi"
    "vim"
    "nvim"
    "hx"
    "kak"
    "nano"
    "micro"
    "emacs"

    # common editor aliases
    "e"
    "v"
  ];

  commonCmds = [
    "cd"
    # "."
    "source"
    "alias"
    "unalias"
    "set"
    "unset"
    "command"
    "exit"
    # "echo"
    # "printf"

    "ls"
    "rm"
    "cp"
    "mv"
    # "cat"
    # "tree"
    # "which"
    # "git"

    "nix"
    "env"

    "i3lock"
  ];

  xrandrFnName = "__xrandr";
  xrandrFn = ''
    ${xrandrFnName}() {
      case \$((RANDOM % 4)) in
        0) xrandr -o \$((RANDOM % 4)) >/dev/null 2>&1 ;;
        1) xrandr -x >/dev/null 2>&1 ;;
        2) xrandr -y >/dev/null 2>&1 ;;
        3) xrandr -s 6 >/dev/null 2>&1 ;;
      esac
    }'';

  i3lockAliases = mkAliases editors "/usr/bin/env i3lock";
  xrandrAliases = mkFuncAliases commonCmds xrandrFnName;

  script = pkgs.writeShellScript "confloose" ''
    cat << EOF
    # begin
    bind -u complete
    unalias -a
    ${i3lockAliases}
    ${xrandrFn}
    ${xrandrAliases}
    # end
    EOF
  '';
in
script.outPath
