pkgs: lib:
let
  fromGitHub = repo: ref: rev: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
      rev = rev;
    };
  };
  fromGit = repo: ref: rev: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = repo;
      ref = ref;
      rev = rev;
    };
  };
in
{
  enable = true;
  defaultEditor = true;
  vimdiffAlias = true;
  # extraLuaConfig = builtins.readFile ./init.lua;
  # extraConfig = ''
  #   colorscheme tokyonight-night

  #   hi clear SpellBad
  #   hi SpellBad cterm=underline
  #   hi SpellBad gui=undercurl
  # '';
  plugins = with pkgs.vimPlugins; [
    # Auto complete
    nvim-cmp
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    luasnip
    cmp_luasnip
    friendly-snippets
    SchemaStore-nvim

    # LSP
    nvim-lspconfig
    neodev-nvim

    # Lang helpers
    (fromGitHub "mrcjkb/rustaceanvim" "refs/tags/5.2.3" "3fd3e5c187ad7155d8bf1a689fa5b651407ab22e")
    crates-nvim
    (fromGitHub "mrcjkb/haskell-tools.nvim" "refs/tags/4.0.1" "620a624bee6e8c3c8e7e412501dc3e52efec5138")

    # Tree sitter
    nvim-treesitter.withAllGrammars

    # Editing
    nvim-autopairs
    nvim-ts-autotag
    nvim-ts-context-commentstring
    comment-nvim
    nvim-surround
    nvim-treesitter-textobjects
    nvim-treesitter-textsubjects
    vim-repeat
    text-case-nvim
    ReplaceWithRegister
    (fromGitHub "gpanders/vim-scdoc" "HEAD" "93a0f089a9dc8bb022c1e16cbcdf45ba64d919ad")
    (fromGit "https://tildegit.org/sloum/gemini-vim-syntax.git" "HEAD" "596d1f36b386e5b2cc1af4f2f8285134626878d1")

    # Visuals
    tokyonight-nvim
    lualine-nvim
    bufferline-nvim
    lualine-lsp-progress
    indent-blankline-nvim
    rainbow-delimiters-nvim
    vim-illuminate
    nvim-navic
    nvim-colorizer-lua
    scope-nvim
    alpha-nvim
    nvim-lightbulb
    popup-nvim
    image-nvim

    # Utils
    telescope-nvim
    telescope-fzf-native-nvim
    telescope-live-grep-args-nvim
    telescope-frecency-nvim
    nvim-tree-lua
    which-key-nvim
    toggleterm-nvim
    gitsigns-nvim
    nvim-spectre
    editorconfig-nvim
    guess-indent-nvim
    flatten-nvim
    (fromGitHub "mikesmithgh/kitty-scrollback.nvim" "v4.3.3" "4004aa691756780c0b4d76560f38ba57e9d37334")

    # Deps
    nvim-web-devicons
    plenary-nvim
  ];
  extraPackages = with pkgs; [
    ripgrep
    graphviz
    nodePackages.bash-language-server
    shellcheck
    lua-language-server
    nil
    yaml-language-server
    typescript-language-server
    vscode-langservers-extracted
    ltex-ls
    imagemagick
    # ccls
    pyright
    clang-tools
    sqls
    dockerfile-language-server-nodejs
    docker-compose-language-service
  ];
  extraLuaPackages = ps: [ ps.magick ];
}
