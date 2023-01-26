{
  config,
  pkgs,
  ...
}: {
  home.username = "halcyon";
  home.homeDirectory = "/home/halcyon";
  home.stateVersion = "22.05";

  xdg = {
    configHome = "${config.home.homeDirectory}/.config";
    cacheHome = "${config.home.homeDirectory}/.cache";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  home.packages = with pkgs; [
    qalculate-gtk
    xournalpp

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
    hmsw = "nix run home-manager -- switch --flake /etc/nixos#halcyon";
    sysw = "sudo nixos-rebuild switch";
  };

  imports = [
    ./foot.nix
    ./firefox.nix
    ./git.nix
    ./gtk.nix
    ./neovim.nix
    ./shell-enhancements.nix
    ./thunderbird.nix
    ./zsh.nix
  ];
}
