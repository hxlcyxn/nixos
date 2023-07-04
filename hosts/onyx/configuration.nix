{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["quiet" "udev.log_level=3" "fbcon=nodefer"];
    initrd.verbose = false;
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };

  networking = {
    hostName = "onyx";
    networkmanager.enable = true;
  };

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "22.11"; # Did you read the comment?
}
