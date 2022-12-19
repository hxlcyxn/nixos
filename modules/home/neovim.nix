{pkgs, ...}: let
  languages = rec {
    lua = with pkgs; [
      lua
      luajit
      sumneko-lua-language-server
      stylua
    ];
    fennel = with pkgs;
      [
        fennel
        fnlfmt
      ]
      ++ lua;
    nix = with pkgs; [
      rnix-lsp
      alejandra
      deadnix
      statix
    ];
  };
in {
  home.packages = with pkgs;
    [
      neovim-nightly
      ripgrep
      fd
    ]
    ++ languages.nix;
}
