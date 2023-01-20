{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.url = "github:nixos/nixpkgs?rev=fad51abd42ca17a60fc1d4cb9382e2d79ae31836";

    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

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
    ...
  } @ inputs: let
    nix-defaults = {
      nix = import ./nix-settings.nix {inherit inputs;};
      nixpkgs = {
        overlays = [
          neovim-nightly-overlay.overlay
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
        ./modules/system/plymouth.nix
        ./modules/system/laptop.nix
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
        sops-nix.nixosModules.sops
        ./modules/system/sops.nix
        {sops.defaultSopsFile = ./secrets/harbinger.yaml;}
        ./hosts/harbinger/configuration.nix
        ./modules/system/laptop.nix

        ./modules/system/fail2ban.nix
        ./modules/system/nextcloud.nix
        # simple-nixos-mailserver.nixosModule
        # ./modules/system/mailserver.nix

        # ./modules/system/ldap.nix

        #nixos-hardware.nixosModules.common-cpu-intel
        #nixos-hardware.nixosModules.common-gpu-nvidia
        #nixos-hardware.nixosModules.common-pc-laptop
        #nixos-hardware.nixosModules.common-pc-laptop-ssd
        #{
        #  hardware.nvidia.prime = {
        #    intelBusId = "PCI:0:2:0";
        #    nvidiaBusId = "PCI:1:0:0";
        #  };
        #}
      ];
    };

    homeConfigurations = {
      halcyon = home-manager.lib.homeManagerConfiguration (import ./modules/home/halcyon {inherit inputs nix-defaults;});
    };
  };
}
