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
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
    gcc
    vim
    wget
    git
    htop
    acpi
    fd
    ripgrep
    pinentry
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
      syntaxHighlighting.enable = true;
      autosuggestions = {
        enable = true;
        async = true;
      };
    };
    gnupg.agent = {
      enable = true;
    };
  };
}
