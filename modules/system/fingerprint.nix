{pkgs, ...}: {
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-tod;
    };
  };
}
