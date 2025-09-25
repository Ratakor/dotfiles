{ pkgs, self, ... }:
{
  hm.programs.zsh.plugins = [
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
    # zsh-helix-mode looks really cool but:
    # - cursor blinks (and is colored in normal/insert mode)
    # - selection doesn't look good on my terminal
    #{
    #  name = "zsh-helix-mode";
    #  file = "zsh-helix-mode.plugin.zsh";
    #  src = "${self.pkgs.zsh-helix-mode}/share/zsh-helix-mode";
    #}
    {
      name = "zsh-vi-mode";
      file = "zsh-vi-mode.plugin.zsh";
      src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
    }
    # {
    #   name = "fast-syntax-highlighting";
    #   file = "fast-syntax-highlighting.plugin.zsh";
    #   src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
    # }
  ];
}
