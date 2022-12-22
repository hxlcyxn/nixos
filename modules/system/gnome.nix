{
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  services.tlp.enable = false;

  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [gnome.adwaita-icon-theme gnomeExtensions.appindicator ];
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}
