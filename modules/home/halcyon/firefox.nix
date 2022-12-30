{config, ...}: {
  programs.firefox = {
    enable = true;
    profiles = {
      "$config.home.username" = {
        id = 0;
        search = {
          default = "DuckDuckGo";
          order = ["DuckDuckGo" "Google"];
        };
      };
    };
  };
}
