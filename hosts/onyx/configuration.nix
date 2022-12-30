# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    kernelParams = ["quiet" "udev.log_level=3" "fbcon=nodefer"];
    plymouth = {
      enable = true;
      theme = "breeze";
    };
    initrd.verbose = false;
    tmpOnTmpfs = true;
    cleanTmpDir = true;
  };

  networking = {
    hostName = "onyx";
    networkmanager.enable = true;
  };

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "22.11"; # Did you read the comment?
}
