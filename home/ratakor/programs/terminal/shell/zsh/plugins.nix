{pkgs, ...}: {
  programs.zsh.plugins = [
    {
      # Must be before plugins that wrap widgets
      # such as zsh-autosuggestions or fast-syntax-highlighting
      # replace zsh's default completion selection menu with fzf
      name = "fzf-tab";
      file = "fzf-tab.plugin.zsh";
      src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
    }
    {
      name = "nix-shell";
      file = "nix-shell.plugin.zsh";
      src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
    }
    {
      name = "zsh-vi-mode";
      file = "zsh-vi-mode.plugin.zsh";
      src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
    }
    {
      # I don't know why but apparently
      # 'programs.zsh.autosuggestion.enable = true;'
      # is not enough
      name = "zsh-autosuggestions";
      file = "zsh-autosuggestions.zsh";
      src = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
    }
    # {
    #   name = "fast-syntax-highlighting";
    #   file = "fast-syntax-highlighting.plugin.zsh";
    #   src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
    # }
  ];
}
