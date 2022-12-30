{
  config,
  lib,
  pkgs,
  ...
}: let
  theme = "breeze";
  plymouth-theme = lib.mkIf (theme != "breeze") pkgs.stdenv.mkDerivation {
    name = "plymouth-theme";
    src = pkgs.fetchFromGitHub {
      owner = "adi1090x";
      repo = "plymouth-themes";
      rev = "bf2f570bee8e84c5c20caac353cbe1d811a4745f";
      sha256 = "sha256-VNGvA8ujwjpC2rTVZKrXni2GjfiZk7AgAn4ZB4Baj2k=";
    };
    configurePkase = ''
      mkdir -p $out/share/plymouth/themes/
    '';
    installPhase = ''
      cp -r $src/pack_*/${theme} $out/share/plymouth/themes
      sed "s@\/usr\/@out\/@" $out/share/plymouth/themes/${theme}
    '';
  };
in {
  boot.plymouth = {
    enable = true;
    inherit theme;
    themePackages = lib.mkIf (config.boot.plymouth.theme != "breeze") [
      plymouth-theme
    ];
  };
}
