{pkgs, lib, fetchFromGitHub, python3Packages, ...}: let
  open-fprintd = pkgs.callPackage ./../../pkgs/open-fprintd.nix { };
  python-validity = pkgs.callPackage ./../../pkgs/python-validity.nix { };
in {
	environment.systemPackages = with pkgs; [fprintd];

	systemd = {
		packages = [open-fprintd python-validity];
		services.pytho3-validity.wantedBy = ["default.target"];
	};

	services.dbus.packages = [open-fprintd python-validity];

	security.pam.services = {
		sudo.fprintAuth = true;
		login.fprintAuth = true;
		# gdm.fprintAuth = true;
	};
}
