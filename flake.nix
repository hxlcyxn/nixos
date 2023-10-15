{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    # unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.url = "https://flakehub.com/f/NixOS/nixos-hardware/*.tar.gz";
    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor";
    };

    # sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.url = "https://flakehub.com/f/Mic92/sops-nix/*.tar.gz";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "unstable";
    };
    neovim-master = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "unstable";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
  };

  outputs = {
    nixpkgs,
    home-manager,
    neovim-nightly-overlay,
    nixpkgs-f2k,
    nixos-hardware,
    sops-nix,
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
        sops-nix
        ./modules/system/sops.nix
        {sops.defaultSopsFile = ./secrets/harbinger.yaml;}
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
