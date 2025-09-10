{
  pins,
  pkgs,
  lib,
  vimPlugins,
}: let
  fs = lib.fileset;
  mnw = import pins.mnw;
in
  mnw.lib.wrap pkgs {
    appName = "nvim-ratakor-mnw";

    desktopEntry = true;

    initLua = ''
      #vim.loader.enable(true)
      require("settings")
      require("lz.n").load("plugins")
    '';

    providers = {
      nodeJs.enable = true;
      perl.enable = false;
      python3.enable = false;
      ruby.enable = false;
    };

    extraBinPath = with pkgs; [
      # idk if these are needed
      tree-sitter
      fzf
      fd
      ripgrep

      # Language servers
      # https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
      # TODO: yaml-language-server
      # TODO: taplo (toml)
      # TODO: vscode-json-languageserver (json)
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

      # Formatters
      alejandra
    ];

    plugins = {
      dev.ratakor = {
        pure = fs.toSource {
          root = ./.;
          # fileset = fs.unions [ ./lua ];
          fileset = fs.fileFilter (file: file.hasExt "lua") ./.;
        };
        impure = null; # unused for exposed package
      };

      start = with vimPlugins; [
        lz-n
        nvim-web-devicons
        plenary-nvim
      ];

      opt = with vimPlugins; [
        # lua/plugins/colorscheme.lua
        gruvbox-nvim

        # lua/plugins/debug.lua
        debugprint-nvim

        # lua/plugins/lsp.lua
        nvim-lspconfig
        neodev-nvim
        nvim-cmp
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
        vim-startify
        comment-nvim
        vim-trailing-whitespace
        gitsigns-nvim
        telescope-nvim
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

        # lua/plugins/noice.lua
        noice-nvim
        nui-nvim
        nvim-notify

        # lua/plugins/treesitter.lua
        nvim-treesitter
        # TODO: install parsers/grammar
        # hlargs-nvim
        markview-nvim
      ];
    };
  }
