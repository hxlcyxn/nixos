{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    hyprland.url = "github:hyprwm/Hyprland";

    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
  };

  outputs = {
    self,
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
          hyprland.overlays.default
          nixpkgs-f2k.overlays.default
        ];
        config = {
          allowUnfree = true;
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
        # ./modules/system/validity.nix

        ./modules/system/gnome.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-t480
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
