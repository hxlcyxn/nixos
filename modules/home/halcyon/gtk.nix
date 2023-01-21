{
  pkgs,
  lib,
  ...
}: let
  gnomeExtensions = with lib.hm.gvariant; {
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
      settings = {
        use-higher-precision = true;
        hot-sensors = mkArray type.string [
          "_processor_usage_"
          "_memory_usage_"
          "__temperature_avg__"
        ];
      };
    };
    sound-output-device-chooser = {
      name = "sound-output-device-chooser";
      uuid = "sound-output-device-chooser@kgshank.net";
    };
  };

  pluginPkgs =
    lib.mapAttrsToList
    (_: {name, ...}: pkgs.gnomeExtensions."${name}")
    gnomeExtensions;
  pluginDconfEnable =
    lib.mapAttrsToList
    (_: {uuid, ...}: uuid)
    gnomeExtensions;
  pluginDconfSettings =
    lib.mapAttrs'
    (_: {
      name,
      settings ? {},
      ...
    }:
      lib.nameValuePair ("org/gnome/shell/extensions/" + name) settings)
    (lib.filterAttrs
      (_: {settings ? {}, ...}: settings != {})
      gnomeExtensions);
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

  dconf.settings =
    {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/wm/preferences" = {
        resize-with-right-button = true;
        action-middle-click-titlebar = "lower";
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = pluginDconfEnable;
      };
    }
    // pluginDconfSettings;

  home.packages = pluginPkgs;
}
