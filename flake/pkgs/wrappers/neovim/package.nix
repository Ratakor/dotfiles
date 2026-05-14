# This isn't maintained, use helix instead.
{
  sources,
  pkgs,
  lib,
  vimPlugins,
}:
let
  fs = lib.fileset;
  mnw = import sources.mnw;
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
    # Telescope deps, rg is also required by nvim
    fd
    ripgrep

    # vimtex deps
    #texliveMinimal # bibtex
    #texlivePackages.biber
    #texlivePackages.latexmk
    #zathura
    #xdotool

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
    zig # ZLS dependency
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
      mini-icons
      plenary-nvim
      nui-nvim

      # treesitter
      nvim-treesitter.withAllGrammars
      markview-nvim
      #hlargs-nvim
      #rainbow-delimiters-nvim

      # lsp & completion
      nvim-lspconfig
      #none-ls-nvim
      #blink-cmp
      nvim-cmp # TODO: replace with blink-cmp
      luasnip
      #vim-snippets # use https://github.com/Ratakor/vim-snippets instead?
      friendly-snippets
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-calc
      cmp-treesitter
      cmp_luasnip

      lualine-nvim
      nvim-web-devicons
      #vim-startify # TODO: replace with alpha-nvim
      comment-nvim
      vim-trailing-whitespace # FixWhitespace
      gitsigns-nvim
      #vim-fugitive
      #vim-rhubarb
      telescope-nvim # TODO: switch to fzf-lua or snacks.nvim?
      telescope-fzf-native-nvim
      undotree
      #copilot-lua
      which-key-nvim
      nerdtree # TODO: switch to chadtree or neo-tree?
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
