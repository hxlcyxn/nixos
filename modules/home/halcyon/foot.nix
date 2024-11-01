{pkgs, ...}: {
  programs.foot = {
    enable = true;
    server.enable = true;

    settings = {
      main = {
        font = "Intel One Mono:size=12";
      };
      cursor = {
        style = "beam";
        blink = "yes";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      colors = with (import ../../../themes/stargaze.nix {mode = "dark";}); {
        foreground = fg;
        background = bg;

        regular0 = black;
        regular1 = red;
        regular2 = green;
        regular3 = yellow;
        regular4 = blue;
        regular5 = purple;
        regular6 = cyan;
        regular7 = lgray;

        bright0 = gray;
        bright1 = lred;
        bright2 = lgreen;
        bright3 = lyellow;
        bright4 = lblue;
        bright5 = lpurple;
        bright6 = lcyan;
        bright7 = llgray;
      };
    };
  };
}
