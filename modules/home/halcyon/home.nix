{
  config,
  pkgs,
  ...
}: {
  home.username = "halcyon";
  home.homeDirectory = "/home/halcyon";
  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    cacheHome = "${config.home.homeDirectory}/.cache";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  home.packages = with pkgs; [
    qalculate-gtk
    xournalpp
    armcord

    wl-clipboard
    xclip
  ];

  home.sessionVariables = let
    nv-cmd = "neovide";
  in {
    EDITOR = nv-cmd;
    VISUAL = nv-cmd;
  };

  home.shellAliases = {
    nixconf = "cd /etc/nixos; nix develop -c $EDITOR";
    hmsw = "home-manager switch --flake /etc/nixos#halcyon";
    sysw = "sudo nixos-rebuild switch";
  };

  fonts.fontconfig.enable = true;

  imports = [
    ./firefox.nix
    ./foot.nix
    ./git.nix
    ./gtk.nix
    ./gnome.nix
    #./hyprland.nix
    ./neovim.nix
    ./qt.nix
    ./rbw.nix
    ./shell-enhancements.nix
    ./ssh.nix
    ./sway.nix
    ./thunderbird.nix
    #./wezterm.nix
    ./zsh.nix
  ];
}
