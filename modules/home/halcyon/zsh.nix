{config, ...}: {
  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    dotDir = "${baseNameOf config.xdg.configHome}/zsh";
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    autocd = true;

    enableAutosuggestions = false;
    enableCompletion = false;
    enableSyntaxHighlighting = false;
    enableVteIntegration = true;
    historySubstringSearch = {
      enable = false;
      searchUpKey = "^[[A";
      searchDownKey = "^[[B";
    };

    # initExtraBeforeCompInit = ''
    #   zstyle ':autocomplete:*' min-delay 0.1
    #   zstyle ':autocomplete:*' min-input 1
    #   zstyle ':autocomplete:*' widget-style menu-select
    # '';
    # plugins = [
    #   {
    #     name = "zsh-autocomplete";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "marlonrichert";
    #       repo = "zsh-autocomplete";
    #       rev = "22.01.21";
    #       sha256 = "sha256-+UziTYsjgpiumSulrLojuqHtDrgvuG91+XNiaMD7wIs=";
    #     };
    #   }
    # ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };
}
