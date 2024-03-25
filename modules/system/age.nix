{config, ...}: {
  age = {
    rekey = {
      masterIdentities = [ ../../secrets/age-yk.pub ];
      storageMode = "local";
      generatedSecretsDir = ../.. + "/secrets/rekeyed/${config.networking.hostName}";
      localStorageDir = ../.. + "/secrets/rekeyed/${config.networking.hostName}";
    };
  };
}
