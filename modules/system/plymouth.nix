{
  config,
  lib,
  pkgs,
  ...
}: let
  theme = "infinite_seal";
  plymouth-themes = pkgs.stdenv.mkDerivation {
    name = "plymouth-themes";
    src = pkgs.fetchFromGitHub {
      owner = "adi1090x";
      repo = "plymouth-themes";
      rev = "bf2f570bee8e84c5c20caac353cbe1d811a4745f";
      sha256 = "sha256-VNGvA8ujwjpC2rTVZKrXni2GjfiZk7AgAn4ZB4Baj2k=";
    };
    installPhase = ''
      mkdir -p $out/share/plymouth/themes/
      cp -r $src/pack_*/${theme} $out/share/plymouth/themes/

      chmod +w $out -R
      find $out -type f | while read file; do
        sed -i 's;/usr/share/plymouth;/etc/plymouth;g' $file
      done
    '';
  };
in {
  boot.plymouth = {
    enable = true;
    inherit theme;
    themePackages = lib.mkIf (config.boot.plymouth.theme != "breeze") [
      plymouth-themes
    ];
  };
}
