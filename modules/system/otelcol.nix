{
  config,
  pkgs,
  lib,
  ...
}: {
  age.secrets.otelcol-config = {
    rekeyFile = ../.. + "/secrets/modules/otelcol/${config.networking.hostName}.yaml.age";
  };
  services.opentelemetry-collector = {
    enable = true;
    package = pkgs.opentelemetry-collector-contrib;
    configFile = config.age.secrets.otelcol-config.path;
  };
  systemd.services.opentelemetry-collector = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "root";
      Group = "root";
    };
  };
}
