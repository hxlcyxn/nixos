{
  pkgs,
  lib,
  ...
}: let
  gnomeExtensions = with lib.hm.gvariant; {
    hide-top-bar = {
      name = "hide-top-bar";
      uuid = "hidetopbar@mathieu.bidon.ca";
    };
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
        hot-sensors = mkArray type.string ["_processor_usage_" "_memory_usage_" "_temperature_processor_0_"];
      };
    };
    sound-output-device-chooser = {
      name = "sound-output-device-chooser";
      uuid = "sound-output-device-chooser@kgshank.net";
    };
    # volume-mixer = {
    #   name = "application-volume-mixer";
    #   uuid = "volume-mixer@evermiss.net";
    # };
  };
  pluginPkgs = lib.mapAttrsToList (_: {name, ...}: pkgs.unstable.gnomeExtensions."${name}") gnomeExtensions;
  pluginDconfEnable = lib.mapAttrsToList (_: {uuid, ...}: uuid) gnomeExtensions;
  pluginDconfSettings = lib.mapAttrs' (_: {
    name,
    settings ? {},
    ...
  }:
    lib.nameValuePair ("org/gnome/shell/extensions/" + name) settings) (lib.filterAttrs (_: {settings ? {}, ...}: settings != {}) gnomeExtensions);
in {
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
      "org/gnome/shell/extensions/hidetopbar" = {
        mouse-sensitive = true;
        keep-round-corners = true;
        enable-active-window = false;
      };
    }
    // pluginDconfSettings;

  home.packages = pluginPkgs;
}
