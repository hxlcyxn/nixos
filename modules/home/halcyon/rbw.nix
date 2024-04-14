{
  programs.rbw = {
    enable = true;
    settings = {
      email = "jonas.seifert04@gmail.com";
      base_url = "https://bw.monono.me/";
      lock_timeout = 60 * 60; # in s
      sync_interval = 10 * 60;
    };
  };
}
