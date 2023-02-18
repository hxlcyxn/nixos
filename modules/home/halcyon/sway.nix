{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      input = {
        "*" = {
          xkb_layout = "de";
          xkb_variant = "nodeadkeys";
        };
      };
      modifier = "Mod4";
    };
  };
}
