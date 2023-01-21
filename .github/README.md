# halcyon's NixOS

<p align="center">![NixOS](https://img.shields.io/badge/NixOS-22.11-blue?logo=nixos)</p>

> **Warning**
> This is a highly experimental config.
> Everything is slowly changing and things might break.

<br />

## Setup

1. Use the latest [NixOS ISO](https://nixos.org/download.html)
2. Format and mount your disks to your liking.
3. Follow these steps, use root if applicable:
```shell
# Get into a Nix shell with Nix unstable and git
nix-shell -p git nixUnstable

# get the config
git clone https://github.com/hxlcyxn/nixos /mnt/etc/nixos

# Remove this file
rm /mnt/etc/nixos/hosts/<your host>/hardware-configuration.nix

# Generate a config and copy the hardware configuration, disregarding the generated configuration.nix
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/<your host>/
rm /mnt/etc/nixos/configuration.nix

# Make sure you're in the configuration directory
cd /mnt/etc/nixos

# Install this NixOS configuration with flakes
nixos-install --flake '.#<host>'
```

4. Reboot, set `root` and user (`halcyon`) password
5. log in as the user
6. Follow these steps:
```shell
# change ownership of configuration folder
sudo chown -R $USER /etc/nixos

# go into the configuration folder
cd /etc/nixos

# Install the home manager configuration
nix run home-manager -- switch --flake ".#<user>"
```

## Credits
* [JavaCafe01/dotfiles](https://github.com/JavaCafe01/dotfiles)
* [fortuneteller2k/nix-config](https://github.com/fortuneteller2k/nix-config)
* [revol-xut/nix-config](https://github.com/revol-xut/nix-config)
