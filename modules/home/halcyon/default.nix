{
  inputs,
  nix-defaults,
}: let
  system = "x86_64-linux";
in {
  modules = [
    ./home.nix
    inputs.chaotic.homeManagerModules.default
  ];
  pkgs = import inputs.nixpkgs {
    inherit system;
    inherit (nix-defaults.nixpkgs) config overlays;
  };

  extraSpecialArgs = {inherit system inputs;};
}
