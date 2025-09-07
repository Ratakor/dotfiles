# Editor
{
  config,
  pkgs,
  ...
}: {
  hm.programs.neovim = {
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
      python313Packages.jedi-language-server # jedi_language_server
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
  # https://ayats.org/blog/neovim-wrapper
  # https://github.com/nix-community/home-manager/issues/2085#issuecomment-2022239332
  # https://foodogsquared.one/posts/2023-03-24-managing-mutable-files-in-nixos/
  hm.xdg.configFile.nvim.source =
    config.hm.lib.file.mkOutOfStoreSymlink
    "${config.user.home}/nixos/modules/home/programs/neovim/nvim";
}
