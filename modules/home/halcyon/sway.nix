{
  pkgs,
  lib,
  ...
}: let
  bg-script = pkgs.writeScriptBin "wp" ''
    usage() {
      printf "usage:\n$ bg <r|rd|s|c> [args]\n"
    }

    case $1 in
      r)
        find $2 -type f \
          | shuf \
          | head -1 \
          | xargs swww img
        ;;
      rd)
        interval=$${$3:-300}
        find $2 -type f \
          | shuf \
          | while read -r img; do
              sww img $img
              sleep $interval
            done
        ;;
      i)
        swww img $2
        ;;
      s)
        convert - size 10x10 xc:$2 /tmp/solidbg.png
        swww img /tmp/solidbg.png
        ;;
      *)
        usage
        exit 1
        ;;
    esac
  '';
in {
  home.packages = with pkgs; [
    nwg-panel
    nwg-drawer
    libnotify

    swww
    bg-script

    brightnessctl
    wluma

    shikane
    swayws
  ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      startup = [
        # {command = "shikane";}
        # {command = "wluma";}
        {commnad = "swww init";}
        {command = "dunst";}
      ];
      input = {
        "type:keyboard" = {
          xkb_layout = "de";
          xkb_variant = "nodeadkeys";
        };
        "type:touchpad" = {
          accel_profile = "flat";
          dwt = "enabled"; # disable-while-typing
          natural_scroll = "disabled";
          tap = "enabled";
        };
      };
      modifier = "Mod4";
      terminal = "foot";
      menu = "nwg-drawer";
      keybindings = lib.mkOptionDefault {
        "${modifier}+n" = "swaync-client -t -sw";
        XF86AudioMute = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        XF86AudioLowerVolume = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1";
        XF86AudioRaiseVolume = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1";
        XF86AudioMicMute = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        XF86MonBrightnessUp = "exec brightnessctl set 1%+";
        XF86MonBrightnessDown = "exec brightnessctl set 1%-";
      };
      bars = [];
    };
  };

  services.shikane = {
    enable = true;
    systemdTarget = ["sway-session.target"];
    config = ''
          [[profile]]
          name = "laptop builtin"
          [[profile.output]]
          match = "eDP-1"
          enable = true

          [[profile]]
          name = "laptop with hdmi"
          [[profile.output]]
          match = "eDP-1"
          enable = true
          exec = ["swayws range --numeric 1 10 $SHIKANE_OUTPUT_NAME"]
          [[profile.output]]
          match = "/HDMI-.-[1-9]/"
          enable = true
          exec = ["swayws range --numeric 11 10 $SHIKANE_OUTPUT_NAME"]
        '';
  };

  systemd.user.services.dunst = {
    Unit = let
      target = "sway-session.target";
    in {
      Description = "Dunst notification daemon";
      PartOf = target;
      BindsTo = target;
      After = target;
    };
  };
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    settings = {
      global = {
        follow = "mouse";
        origin = "top-right";
        width = "(128, 380)";
        height = 50;
        offset = "16x16"; # HORxVERT
        gap_size = 4;
      };
    };
  };

  xdg.configFile."wluma/config.toml".text = ''
    [als.webcam]
    video = 0
    thresholds = { 0 = "night", 15 = "dark", 30 = "dim", 45 = "normal", 60 = "bright", 75 = "outdoors" }

    # [als.time]
    # thresholds = { 0 = "night", 7 = "dark", 9 = "dim", 11 = "normal", 13 = "bright", 16 = "normal", 18 = "dark", 20 = "night" }

    # [als.none]

    [[output.backlight]]
    name = "eDP-1"
    path = "/sys/class/backlight/intel_backlight"
    capturer = "wlroots"

    [[keyboard]]
    name = "keyboard"
    path = "/sys/bus/platform/devices/thinkpad_acpi/leds/tpacpi::kbd_backlight"
  '';
}
