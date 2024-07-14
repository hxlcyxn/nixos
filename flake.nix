{
  inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix-rekey.url = "github:oddlama/agenix-rekey";
    home-manager.url = "github:nix-community/home-manager";
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-06cb-009a-fingerprint-sensor.url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "stable";

    agenix.inputs.darwin.follows = "";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.nixpkgs.follows = "unstable";
    nixos-06cb-009a-fingerprint-sensor.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    agenix,
    agenix-rekey,
    home-manager,
    nixpkgs-f2k,
    chaotic,
    nixos-hardware,
    hyprland,
    ...
  } @ inputs: let
    nix-defaults = {
      nix = import ./nix-settings.nix {inherit inputs;};
      nixpkgs = {
        overlays = [
          agenix.overlays.default
          agenix-rekey.overlays.default
          hyprland.overlays.default
          nixpkgs-f2k.overlays.default

          (
            final: _prev: {
              stable = import inputs.stable {
                inherit (final) system;
                config = {
                  allowUnfree = true;
                  allowBroken = true;
                };
              };
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

        agenix.nixosModules.default
        agenix-rekey.nixosModules.default
        ./modules/system/age.nix
        {age.rekey.hostPubkey = ./secrets/hosts/onyx.pub;}

        # chaotic.nixosModules.default
        nix-defaults

        ./modules/system/laptop.nix
        ./modules/system/plymouth.nix
        ./modules/system/smart.nix

        ./modules/system/yubikey.nix
        ./modules/system/t480-fingerprint.nix
        # ./modules/system/validity.nix

        ./modules/system/tailscale.nix

        ./modules/system/ime.nix

        # ./modules/system/steam.nix
        # ./modules/system/ananicy.nix
        ./modules/system/gnome.nix
        ./modules/system/sway.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-t480

        # ./modules/system/otelcol.nix
        # only needed for initial setup
        # nixos-06cb-009a-fingerprint-sensor.nixosModules.open-fprintd
        # nixos-06cb-009a-fingerprint-sensor.nixosModules.python-validity
      ];
    };

    homeConfigurations = {
      halcyon = home-manager.lib.homeManagerConfiguration (import ./modules/home/halcyon {inherit inputs nix-defaults;});
    };

    agenix-rekey = agenix-rekey.configure {
      userFlake = self;
      nodes = self.nixosConfigurations;
    };
  };
}
