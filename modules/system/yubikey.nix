{pkgs, ...}: {
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    polkit1.u2fAuth = true;
  };

  environment.systemPackages = with pkgs; [
    yubikey-touch-detector
  ];
}
