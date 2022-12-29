{config, ...}: {
  home.username = "halcyon";
  home.homeDirectory = "/home/halcyon";
  home.stateVersion = "22.05";

  xdg = {
    configHome = "${config.home.homeDirectory}/.config";
    cacheHome = "${config.home.homeDirectory}/.cache";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  imports = [
    ./foot.nix
    ./git.nix
    ./neovim.nix
    ./shell-enhancements.nix
    ./zsh.nix
  ];
}
