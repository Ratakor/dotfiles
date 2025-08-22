# fuzzy finder
# TODO: none of this work
{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;

  previewer = pkgs.writeShellApplication {
    name = "fzf-preview";
    runtimeInputs = with pkgs; [file bat chafa];
    text = builtins.readFile ./previewer.sh;
  };
in {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # enables widgets

    defaultCommand = "${getExe pkgs.fd} --type f --type l --strip-cwd-prefix --hidden --exclude .git"; # --follow
    defaultOptions = [
      "--height=~50%"
      # "--layout=reverse"
    ];

    # CTRL-T
    fileWidgetCommand = "${getExe pkgs.fd} --type f --type l --strip-cwd-prefix --hidden --exclude .git";
    fileWidgetOptions = [
      "--preview='${getExe previewer} {}'"
    ];

    # ALT-C
    changeDirWidgetCommand = "${getExe pkgs.fd} --type d --strip-cwd-prefix --hidden --exclude .git";
    changeDirWidgetOptions = [
      "--preview='${getExe pkgs.eza} --icons --color always -T -L 3 {} | head -200'"
    ];

    # CTRL-R
    historyWidgetOptions = [];

    # colors = {};
  };
}
