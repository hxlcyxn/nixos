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
  ];

  imports = [
    ./foot.nix
    ./firefox.nix
    ./git.nix
    ./neovim.nix
    ./shell-enhancements.nix
    ./zsh.nix
  ];
}
