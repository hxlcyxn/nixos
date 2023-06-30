{pkgs, ...}: {
  home.packages = with pkgs; [iosevka-bin];
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm-git;
    colorSchemes = with (import ../../../themes/stargaze.nix {mode = "dark";}); {
      stargaze_night = {
        ansi = [black red green yellow blue purple cyan llgray];
        brights = [gray lred lgreen lyellow lblue lpurple lcyan lgray];
        background = bg;
        cursor_bg = fg;
        cursor_border = fg;
        cursor_fg = bg;
        foreground = fg;
        selection_bg = gray;
        selection_fg = llgray;
      };
    };
    extraConfig = ''
      return {
        font = wezterm.font("Iosevka"),
        font_size = 10,
        color_scheme = "stargaze_night",
      }
    '';
  };
}
