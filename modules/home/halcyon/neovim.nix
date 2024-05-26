{pkgs, ...}: {
  home.packages = with pkgs; [
    unstable.neovide

    ripgrep
    fd
    glow
    chafa
    file
    imagemagick

    alejandra
    deadnix
    nil
    nixd
    statix

    selene
    stylua
    sumneko-lua-language-server
  ];
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
    nv = "neovide --fork";
  };

  xdg.desktopEntries = {
    neovide = {
      name = "Neovide";
      type = "Application";
      exec = "neovide %F";
      icon = "neovide";
      comment = "No Nonsense neovim Client in Rust";
      categories = ["Utility" "TextEditor"];
      mimeType = ["text/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++"];
    };
  };
}
