{
  config,
  pkgs,
  ...
}: {
  services.spotifyd = {
    enable = false;
    settings = {
      global = {
        username = "jopro1234";
        password_cmd = "cat ${config.xdg.configHome}/spotifyd/password";
        use_keyring = false;
        use_mpris = true;
        bitrate = 320;
        device_type = "computer";
      };
    };
  };
  # TODO: wait for 24.05
  home.packages = with pkgs; [spotify-player];
  # programs.spotify-player = {
  #   enable = true;
  # };
}
