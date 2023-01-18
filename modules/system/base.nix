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

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://nix-community.cachix.org"
        "https://fortuneteller2k.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  services = {
    printing.enable = true;
    openssh.enable = true;
    fwupd.enable = true;
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
      promptInit = "export PS1=\"%B%F{blue}%1d | %f%b\"";
    };
    gnupg.agent = {
      enable = true;
    };
  };
}
