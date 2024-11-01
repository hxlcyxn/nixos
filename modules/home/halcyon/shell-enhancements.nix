{
  programs.eza = {
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

  programs.fzf = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
    defaultOptions = ["--layout=reverse" "--height=30%"];
  };
}
