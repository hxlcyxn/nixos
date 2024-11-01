{
  config,
  pkgs,
  ...
}: {
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

    autosuggestion.enable = false;
    enableCompletion = false;
    syntaxHighlighting = {
      enable = false;
    };
    enableVteIntegration = true;
    historySubstringSearch = {
      enable = false;
      searchUpKey = "^[[A";
      searchDownKey = "^[[B";
    };

    plugins = with pkgs; [
      {
        name = "zsh-autocomplete";
        src = zsh-autocomplete.src;
      }
    ];

    # initExtraBeforeCompInit = ''
    #   zstyle ':autocomplete:*' min-delay 0.1
    #   zstyle ':autocomplete:*' min-input 1
    #   zstyle ':autocomplete:*' widget-style menu-select
    # '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };
}
