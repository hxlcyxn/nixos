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
      neovide
      ripgrep
      fd
    ]
    ++ languages.nix;
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    viAlias = true;
    vimAlias = true;
  };
}
