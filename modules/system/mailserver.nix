{config, ...}: let
  domainName = "eisvogel.moe";
in {
  sops.secrets = {
    "mailserver_halcyon".owner = config.users.users.halcyon.name;
    # "mailserver_vaultwarden".owner = config.users.users.vaultwarden.name;
  };

  mailserver = {
    enable = true;
    enableImap = true;
    enableImapSsl = true;
    enableManageSieve = true;
    enableSubmission = true;
    enableSubmissionSsl = true;

    fqdn = "mail.${domainName}";
    domains = [domainName];

    loginAccounts = {
      "halcyon@${domainName}" = {
        name = "halcyon";
        hashedPasswordFile = config.sops.secrets.mailserver-halcyon.path;
      };
      # "bitwarden@${domainName}" = {
      #   name = "bitwarden";
      #   hashedPasswordFile = config.sops.secrets.mailserver-vaultwarden.path;
      # };
    };
    certificateScheme = 3;
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "jonas.seifert04@gmail.com";
}
