{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = false;
    vimAlias = false;
    vimdiffAlias = true;

    # withNodeJs = true;
    # withPython3 = true;
    # withRuby = true;

    extraPackages = with pkgs; [
      tree-sitter

      # LSPs
      # https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
      bash-language-server # bashls
      clang # clangd
      vscode-css-languageserver # cssls
      gopls # gopls
      # python313Packages.jedi-language-server # jedi_language_server # TODO: fails to build
      lua-language-server # lua_ls
      marksman # marksman
      nil # nil_ls (TODO: see nixd)
      rust-analyzer # rust_analyzer
      sqls # sqls
      superhtml # superhtml
      texlab # texlab
      vtsls # vtsls
      zls # zls
    ];
  };

  # TODO: manage nvim config with nixvim or nvf or whatever instead of doing
  # impure out of store symlinks even though I like mutable config
  xdg.configFile.nvim.source = "${config.home.dotfiles}/programs/terminal/editor/nvim";
}
