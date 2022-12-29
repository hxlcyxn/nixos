{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    firefox
    qalculate-gtk
    thunderbird
  ];
}
