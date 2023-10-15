{pkgs, lib, ...}: {
  imports = [./xserver.nix];
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  services.tlp.enable = false;

  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [gnome.adwaita-icon-theme gnomeExtensions.appindicator gnome.gnome-tweaks];
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  services.gnome.gnome-keyring.enable = lib.mkForce false;

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-tour
      orca # screen reader
    ])
    ++ (with pkgs.gnome; [
      geary # email
      # totem # video
      epiphany # browser
      gnome-contacts
      gnome-initial-setup
      yelp # help
    ])
    ++ (with pkgs.gnome; [
      # games
      tali
      iagno
      hitori
      atomix
    ]);
}
