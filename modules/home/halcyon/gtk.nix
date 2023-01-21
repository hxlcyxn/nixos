{
  pkgs,
  lib,
  ...
}: let
  gnomeExtensions = {
    workspace-indicator = {
      name = "workspace-indicator-2";
      uuid = "horizontal-workspace-indicator@tty2.io";
    };
    tray-icons = {
      name = "tray-icons-reloaded";
      uuid = "trayIconsReloaded@selfmade.pl";
    };
    vitals = {
      name = "vitals";
      uuid = "Vitals@CoreCoding.com";
    };
    sound-output-device-chooser = {
      name = "sound-output-device-chooser";
      uuid = "sound-output-device-chooser@kgshank.net";
    };
  };

  pkgsGnomeExtensions = lib.mapAttrsToList (_: {
    name,
    uuid,
  }:
    pkgs.gnomeExtensions."${name}")
  gnomeExtensions;
  dconfGnomeExtensions = lib.mapAttrsToList (_: {
    name,
    uuid,
  }:
    uuid)
  gnomeExtensions;
in {
  gtk = {
    enable = true;

    cursorTheme = {
      name = "phinger-cursors";
      package = pkgs.phinger-cursors;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "phocus";
      package = pkgs.phocus;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/wm/preferences" = {
      resize-with-right-button = true;
      action-middle-click-titlebar = "lower";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = dconfGnomeExtensions;
    };
  };

  home.packages = pkgsGnomeExtensions;
}
