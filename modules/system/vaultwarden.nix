{config, ...}: let
  domain = "eisvogel.moe";
  bwDomain = "bw.${domain}";
in {
  sops.secrets = {
    "mailserver_vaultwarden".owner = config.users.users.vaultwarden.name;
  };

  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://${bwDomain}";
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8812;
      WEB_VAULT_ENABLED = true;

      SMTP_HOST = "mail.${domain}";
      SMTP_FROM = "bw@${domain}";
      SMTP_FROM_NAME = "Vaultwarden";
      SMTP_PORT = 587;
      SMTP_SECURITY = "starttls";
      SMTP_USERNAME = "bitwarden@${domain}";
      SMTP_PASSWORD = "bw_7468!cockyballs"; # no path config EL CRINGE

      #ADMIN_TOKEN = "AfVWbruh";
    };
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."${bwDomain}" = {
      forceSSL = true;
      sslCertificate = ./../../cert.pem;
      sslCertificateKey = ./../../key.pem;
      locations = {
        "/" = {
          proxyPass = "http://localhost:8812";
          proxyWebsockets = true;
        };
        "/notifications/hub" = {
          proxyPass = "http://localhost:3012";
          proxyWebsockets = true;
        };
        "/notifications/hub/negotiate" = {
          proxyPass = "http://localhost:8812";
          proxyWebsockets = true;
        };
      };
    };
  };
}
