{
  pkgs,
  ...
}: {
  imports = [
    ./base.nix
    ./bluetooth.nix
    ./pipewire.nix
    ./tlp.nix
    ./printing.nix
  ];

  users.users.halcyon = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    initialPassword = "1234";
    shell = pkgs.zsh;
  };
}
