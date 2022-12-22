{pkgs, ...}: {
  services.fingerprint = {
    enable = true;
    tod = {
      enable = true;
      package = pkgs.libfprint-tod;
    };
  };
}
