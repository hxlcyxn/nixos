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

    wl-clipboard
    xclip

    cozette
    fira-code
    iosevka-bin
    monocraft
    unstable.intel-one-mono
  ];

  home.sessionVariables = {
    EDITOR = "neovide";
    VISUAL = "neovide";

    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    GDK_DPI_SCALE = "1";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland,x11";
    WINIT_UNIX_BACKEND = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  home.shellAliases = {
    nixconf = "cd /etc/nixos; nix develop -c $EDITOR";
    hmsw = "home-manager switch --flake /etc/nixos#halcyon";
    sysw = "sudo nixos-rebuild switch";
  };

  fonts.fontconfig.enable = true;

  imports = [
    ../custom

    ./firefox.nix
    ./foot.nix
    ./git.nix
    ./gnome.nix
    ./gtk.nix
    ./kubernetes.nix
    ./neovim.nix
    ./qt.nix
    ./rbw.nix
    ./shell-enhancements.nix
    ./ssh.nix
    ./sway.nix
    ./thunderbird.nix
    # ./wezterm.nix
    ./zsh.nix
  ];
}
