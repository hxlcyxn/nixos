{
  pkgs,
  config,
  ...
}: {
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1-nodeadkeys";
  };

  nixpkgs.config.allowUnfree = true;

  services = {
    printing.enable = true;
    openssh.enable = true;
    fwupd.enable = true;
  };

  security.sudo = {
    extraConfig = ''
      Defaults insults
      Defaults pwfeedback
    '';
  };

  environment.systemPackages = with pkgs; [
    acpi
    alejandra
    fd
    gcc
    git
    htop
    pinentry
    ripgrep
    statix
    vim
    wget
  ];

  environment.variables = rec {
    EDITOR = "vim";
    VISUAL = "vim";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    ZDOTDIR = "${XDG_CONFIG_HOME}/zsh";
  };

  programs = {
    zsh = {
      enable = true;
      histSize = 1000;
      histFile = "${config.environment.variables.XDG_DATA_HOME}/zsh/history";
      enableGlobalCompInit = false;
      enableCompletion = false;
      syntaxHighlighting.enable = false;
      autosuggestions.enable = false;
      promptInit = ''export PS1="%B%F{blue}%1d | %f%b"'';
    };
    gnupg.agent = {
      enable = true;
    };
  };
}
