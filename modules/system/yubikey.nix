{pkgs, ...}: {
  security.pam.u2f = {
    enable = true;
    cue = true;
    control = "sufficient";
  };

  environment.systemPackages = with pkgs; [
    yubikey-touch-detector
  ];
}
