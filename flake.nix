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

    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    neovim-nightly-overlay,
    nixos-hardware,
    simple-nixos-mailserver,
    sops-nix,
    ...
  } @ inputs: let
    halcyon = [
      {
        nixpkgs.overlays = [
          neovim-nightly-overlay.overlay
        ];
      }
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit inputs;};
          users.halcyon = {
            imports = [./modules/home/halcyon.nix];
          };
        };
      }
      nixos-hardware.nixosModules.lenovo-thinkpad-t480
    ];
  in{
    nixosConfigurations.onyx = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/onyx/configuration.nix
        ./modules/system/laptop.nix
        # ./modules/system/validity.nix

	./modules/system/desktop.nix
        ./modules/system/gnome.nix
      ] ++ halcyon;
    };
    nixosConfigurations.harbinger = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        sops-nix.nixosModules.sops
        ./modules/system/sops.nix
        { sops.defaultSopsFile = ./secrets/harbinger.yaml; }
        ./hosts/harbinger/configuration.nix
        ./modules/system/laptop.nix

        ./modules/system/fail2ban.nix
        ./modules/system/nextcloud.nix
        # ./modules/system/vaultwarden.nix

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
      ] ++ halcyon;
    };
  };
}
