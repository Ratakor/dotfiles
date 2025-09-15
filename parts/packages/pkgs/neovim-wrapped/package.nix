{
  pins,
  pkgs,
  lib,
  vimPlugins,
}:
let
  fs = lib.fileset;
  mnw = import pins.mnw;
in
mnw.lib.wrap pkgs {
  appName = "nvim-ratakor-mnw";

  desktopEntry = true;

  initLua = ''
    require("self")
  '';

  providers = {
    nodeJs.enable = true;
    perl.enable = false;
    python3.enable = false;
    ruby.enable = false;
  };

  extraBinPath = with pkgs; [
    # idk if these are needed
    # tree-sitter
    # fzf
    # fd
    # ripgrep

    # Language servers
    # https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    # TODO: yaml-language-server
    # TODO: taplo (toml)
    # TODO: vscode-json-languageserver (json)
    bash-language-server # bashls
    clang-tools # clangd
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

    # Formatters
    nixfmt
  ];

  plugins = {
    dev.self = {
      pure = fs.toSource {
        root = ./.;
        # fileset = fs.unions [ ./lua ];
        fileset = fs.fileFilter (file: file.hasExt "lua") ./.;
      };
      impure = null; # unused for exposed package
    };

    start = with vimPlugins; [
      lz-n
      gruvbox-nvim

      # deps
      nvim-web-devicons
      plenary-nvim
      nui-nvim

      # treesitter
      nvim-treesitter.withAllGrammars
      hlargs-nvim
      # rainbow-delimiters-nvim
      markview-nvim
      # ];

      # opt = with vimPlugins; [

      # lua/plugins/debug.lua
      debugprint-nvim

      # lua/plugins/lsp.lua
      nvim-lspconfig
      neodev-nvim # TODO: replace with lazydev/none-ls idk
      # none-ls-nvim
      # lazydev-nvim
      # blink-cmp
      nvim-cmp # TODO: replace with blink-cmp or care.nvim
      luasnip
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-calc
      cmp-treesitter
      cmp_luasnip

      # lua/plugins/misc.lua
      lualine-nvim
      nvim-web-devicons
      # vim-startify
      comment-nvim
      vim-trailing-whitespace # FixWhitespace
      gitsigns-nvim
      # vim-fugitive
      # vim-rhubarb
      telescope-nvim
      telescope-fzf-native-nvim
      plenary-nvim
      undotree
      copilot-lua
      neotest
      nvim-nio
      plenary-nvim
      FixCursorHold-nvim
      neotest-zig
      which-key-nvim
      nerdtree
      vim-abolish
      zig-vim
      nvim-scrollbar
      vimtex
      comfy-line-numbers-nvim
    ];

    opt = with pkgs.vimPlugins; [
      nvim-notify
      noice-nvim
    ];
  };
}
