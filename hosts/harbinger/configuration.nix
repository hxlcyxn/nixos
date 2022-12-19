# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./network.nix
  ];

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    kernelParams = ["nohibernate"];

    tmpOnTmpfs = true;
    cleanTmpDir = true;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };

    supportedFilesystems = ["zfs"];
    zfs.devNodes = "/dev/";
  };

  services.zfs = {
    autoSnapshot = {
      enable = true;
      frequent = 4;
      hourly = 6;
      daily = 6;
      weekly = 2;
      monthly = 1;
    };
    trim.enable = true;
    autoScrub.enable = true;
  };

  services.logind.lidSwitchExternalPower = "ignore";

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "22.05"; # Did you read the comment?
}
