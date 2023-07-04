{inputs, ...}: let
  fp = inputs.nixos-06cb-009a-fingerprint-sensor;
in {
  # incompatible with some services, needed to enroll fingerprints
  # services.open-fprintd.enable = true;
  # services.python-validity.enable = true;

  # security.pam.services.sudo.text = ''
  #   # Account management.
  #   account required pam_unix.so
  #
  #   # Authentication management.
  #   auth sufficient ${fp.localPackages.fprintd-clients}/lib/security/pam_fprintd.so
  #   auth sufficient pam_unix.so   likeauth try_first_pass nullok
  #   auth required pam_deny.so
  #
  #   # Password management.
  #   password sufficient pam_unix.so nullok sha512
  #
  #   # Session management.
  #   session required pam_env.so conffile=/etc/pam/environment readenv=0
  #   session required pam_unix.so
  # '';

  # apparently cannot enroll new fingerprints but is perfectly working
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = fp.lib.libfprint-2-tod1-vfs0090-bingch {calib-data-file = ../../hosts/onyx/calib-data.bin;};
    };
  };
}
