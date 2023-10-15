{pkgs, ...}: {
  security.pam.u2f = {
    enable = true;
    cue = true;
    control = "sufficient";
  };

  services = {
    pcscd.enable = true;
  };

  programs = {
    yubikey-touch-detector.enable = true;
  };

  environment.systemPackages = with pkgs; [
    yubikey-touch-detector
    yubikey-manager
    yubikey-manager-qt
  ];
}
