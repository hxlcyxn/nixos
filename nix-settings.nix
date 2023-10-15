{inputs}: {
  gc = {
    automatic = true;
    persistent = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  optimise = {
    automatic = true;
    dates = ["01:00" "18:30"];
  };

  nixPath = [
    "repl=${toString ./.}/repl.nix"
    "nixpkgs=${inputs.nixpkgs}"
    "home-manager=${inputs.home-manager}"
  ];

  registry = {
    system.flake = inputs.self;
    default.flake = inputs.nixpkgs;
    home-manager.flake = inputs.home-manager // {config.allowUnfree = true;};
    unstable.flake = inputs.unstable;
  };

  settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    allowed-users = ["root" "halcyon"];
    substituters = [
      "https://cache.nixos.org?priority=10"
      "https://nix-community.cachix.org"
      "https://fortuneteller2k.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    trusted-users = ["root" "halcyon"];
  };
}
