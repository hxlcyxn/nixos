{
  pkgs,
  lib,
  ...
}: {
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
}
