{
  config,
  pkgs,
  ...
}: let
  domain = "eisvogel.moe";
in {
  sops.secrets."nextcloud_admin".owner = "nextcloud";

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud25;
    hostName = "nc.${domain}";
    https = true;
    config = {
      extraTrustedDomains = ["localhost" "harbinger"];
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbname = "nextcloud";
      adminuser = "root";
      adminpassFile = config.sops.secrets."nextcloud_admin".path;
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = ["nextcloud"];
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }
    ];
  };

  services.nginx.virtualHosts."nc.${domain}" = {
    forceSSL = true;
    sslCertificate = ./../../cert.pem;
    sslCertificateKey = ./../../key.pem;
  };

  systemd.services."nextcloud-setup" = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
