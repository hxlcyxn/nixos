{pkgs, ...}: {
  imports = [
    ./base.nix
    ./bluetooth.nix
    ./pipewire.nix
    ./tlp.nix
    ./printing.nix
  ];

  users.users.halcyon = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "networkmanager"];
    initialPassword = "1234";
    shell = pkgs.zsh;
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
  '';
}
