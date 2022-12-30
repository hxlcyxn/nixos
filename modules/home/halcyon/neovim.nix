{pkgs, ...}: {
  home.packages = with pkgs; [
    neovide
    ripgrep
    fd
  ];
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
