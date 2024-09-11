pkgs: {
  enable = true;
	package = pkgs.helix;
  extraPackages = with pkgs; [
    ripgrep
    graphviz
    nodePackages.bash-language-server
    shellcheck
    lua-language-server
    nil
    yaml-language-server
    vscode-langservers-extracted
    ltex-ls
    imagemagick
    dockerfile-language-server-nodejs
    clang-tools
  ];
}
