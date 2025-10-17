# nix run github:ratakor/dotfiles#confloose --accept-flake-config >> ~/.bashrc
{ pkgs }:
let
  inherit (builtins) concatStringsSep;

  mkAliases =
    aliases: cmd: aliases |> map (alias: "alias '${alias}'='${cmd}'") |> concatStringsSep "\n";

  # These "aliases" can't be cancelled by prefixing the command with '\'
  # I'm pretty sure eval is not needed
  mkFuncAliases =
    aliases: cmd: aliases |> map (alias: "eval '${alias}() { ${cmd}; }'") |> concatStringsSep "\n";

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

  i3lockAliases = mkAliases editors "i3lock";
  xrandrAliases = mkFuncAliases commonCmds xrandrFnName;
in
pkgs.writeShellApplication {
  name = "confloose";
  text = ''
    cat << EOF
    # begin
    unalias -a
    ${i3lockAliases}
    ${xrandrFn}
    ${xrandrAliases}
    # end
    EOF
  '';
}
