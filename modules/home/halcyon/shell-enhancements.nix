{
  programs.exa = {
    enable = true;
    # enableAliases = true;
  };
  home.shellAliases = {
    ls = "exa --icons --group-directories-first";
    la = "ls -lah";
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "OneHalfLight";
    };
  };
}
