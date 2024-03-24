{
  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    hyprland.url = "github:hyprwm/Hyprland";
    neovim-master.url = "github:neovim/neovim?dir=contrib";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixos-06cb-009a-fingerprint-sensor.url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "stable";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.nixpkgs.follows = "unstable";
    neovim-master.inputs.nixpkgs.follows = "unstable";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "unstable";
    nixos-06cb-009a-fingerprint-sensor.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    home-manager,
    neovim-nightly-overlay,
    nixpkgs-f2k,
    nixos-hardware,
    hyprland,
    ...
  } @ inputs: let
    nix-defaults = {
      nix = import ./nix-settings.nix {inherit inputs;};
      nixpkgs = {
        overlays = [
          neovim-nightly-overlay.overlay
          (
            final: prev: {
              neovim-master = inputs.neovim-master.packages."${final.system}".neovim;
            }
          )
          hyprland.overlays.default
          nixpkgs-f2k.overlays.default

          (
            final: _prev: {
              unstable = import inputs.unstable {
                inherit (final) system;
                config = {
                  allowUnfree = true;
                  allowBroken = true;
                };
              };
            }
          )
        ];
        config = {
          allowUnfree = true;
          allowBroken = true;
        };
      };
    };
  in {
    nixosConfigurations.onyx = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/onyx/configuration.nix
        nix-defaults
        ./modules/system/laptop.nix
        ./modules/system/plymouth.nix

        ./modules/system/yubikey.nix
        ./modules/system/t480-fingerprint.nix
        # ./modules/system/validity.nix

        ./modules/system/tailscale.nix

        ./modules/system/ime.nix

        ./modules/system/steam.nix
        ./modules/system/ananicy.nix
        ./modules/system/gnome.nix
        ./modules/system/sway.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-t480
        # only needed for initial setup
        # nixos-06cb-009a-fingerprint-sensor.nixosModules.open-fprintd
        # nixos-06cb-009a-fingerprint-sensor.nixosModules.python-validity
      ];
    };
    nixosConfigurations.harbinger = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/harbinger/configuration.nix
        nix-defaults
        ./modules/system/laptop.nix
        ./modules/system/plymouth.nix

        ./modules/system/fail2ban.nix
      ];
    };

    homeConfigurations = {
      halcyon = home-manager.lib.homeManagerConfiguration (import ./modules/home/halcyon {inherit inputs nix-defaults;});
    };
  };
}
