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

  initLua =
    # lua
    ''
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
    #tree-sitter
    #fzf
    #fd
    #ripgrep

    # Language servers
    # https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    bash-language-server # bashls (Bash)
    clang-tools # clangd (C/C++)
    vscode-css-languageserver # cssls (CSS)
    gopls # gopls (Go)
    python313Packages.jedi-language-server # jedi_language_server (Python)
    lua-language-server # lua_ls (Lua)
    marksman # marksman (Markdown)
    # nixd # nixd (Nix)
    nil # nil_ls (Nix)
    rust-analyzer # rust_analyzer (Rust)
    sqls # sqls (SQL)
    superhtml # superhtml (HTML)
    taplo # taplo (TOML)
    texlab # texlab (LaTeX)
    vscode-json-languageserver # jsonls (JSON)
    vtsls # vtsls (JS/TS)
    yaml-language-server # yamlls (YAML)
    zls # zls (Zig)

    # Formatters
    nixfmt
  ];

  extraLuaPackages = lp: [
    # LuaSnip dependency
    lp.jsregexp
  ];

  plugins = {
    dev.self = {
      pure = fs.toSource {
        root = ./.;
        fileset = fs.unions [ ./lua ];
        # fileset = fs.fileFilter (file: file.hasExt "lua") ./.;
      };
      impure = null; # unused
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
      markview-nvim
      # hlargs-nvim
      # rainbow-delimiters-nvim
      # ];

      # opt = with vimPlugins; [

      nvim-lspconfig
      # none-ls-nvim
      # blink-cmp
      nvim-cmp # TODO: replace with blink-cmp or care.nvim
      luasnip
      vim-snippets # use https://github.com/Ratakor/vim-snippets instead?
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-calc
      cmp-treesitter
      cmp_luasnip

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
      undotree
      copilot-lua
      which-key-nvim
      nerdtree
      vim-abolish
      zig-vim
      nvim-scrollbar
      vimtex
      comfy-line-numbers-nvim
      debugprint-nvim
    ];

    opt = with pkgs.vimPlugins; [
      nvim-notify
      noice-nvim
      lazydev-nvim
    ];
  };
}
