{
  # home.file."firefox-gnome-theme" = {
  #   target = ".mozilla/firefox/default/chrome/firefox-gnome-theme";
  #   source = (fetchTarball {
  #     url = "https://github.com/rafaelmardojai/firefox-gnome-theme/archive/refs/tags/v126.tar.gz";
  #     sha256 = "1r6vvhzk8gwhs78k54ppsxzfkw7lbldjivydy87ij6grj3cf6mld";
  #   });
  # };
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        search = {
          default = "DuckDuckGo";
          order = ["DuckDuckGo" "Google"];
          force = true;
        };
        # settings = {
        #   "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        #   "browser.tabs.drawInTitlebar" = true;
        #   "svg.context-properties.content.enabled" = true;
        # };
        # userChrome = ''
        #   @import "firefox-gnome-theme/userChrome.css";
        # '';
        # userContent = ''
        #   @import "firefox-gnome-theme/userContent.css";
        # '';
      };
    };
  };
}
