{
  config,
  pkgs,
  lib,
  ...
}: let
  bg-script = pkgs.writeScriptBin "wp" ''
    usage() {
      printf "usage:\n$ bg <r|rd|i|s> [args]\n"
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
        convert -size 1x1 xc:$2 /tmp/solidbg.png
        swww img /tmp/solidbg.png
        ;;
      *)
        usage
        exit 1
        ;;
    esac
  '';
  statusCommand = pkgs.writeScript "status_command" ''
    #!/bin/sh

    while :; do
        energy_full=
        energy_now=
        charge=

        for bat in /sys/class/power_supply/*/capacity; do
            bat="''${bat%/*}"
            read -r full < $bat/energy_full
            read -r now < $bat/energy_now
            energy_full=$((energy_full + full))
            energy_now=$((energy_now + now))
        done

        if cat /sys/class/power_supply/*/status | grep -q Charging; then
            charge=+
        fi

        printf '%s %s ' "$charge$((energy_now * 100 / energy_full))%" "$(date +'%H:%M')"

        sleep 3
    done
  '';
in {
  home.packages = with pkgs; [
    nwg-drawer
    wlogout
    autotiling-rs
    wob
    libnotify

    swww
    bg-script

    brightnessctl
    wluma

    shikane
    swayws

    monocraft
  ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      startup = [
        # {command = "shikane";}
        # {command = "wluma";}
        {command = "swww init; sleep 5; wp r ${config.home.homeDirectory}/Pictures/Wallpapers";}
        {command = "dunst";}
        {command = "autotiling-rs";}
        {command = "rm -f /tmp/wob.sock && mkfifo /tmp/wob.sock && tail -f /tmp/wob.sock | wob";}
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
      left = "h";
      down = "j";
      up = "k";
      right = "l";
      terminal = "foot";
      menu = "nwg-drawer";
      keybindings = let
        next = "$(swaymsg -t get_workspaces | ${pkgs.jq}/bin/jq -r '.[] | select(.focused).name' | awk '{print $1 % 10 + 1}')";
        previous = "$(swaymsg -t get_workspaces | ${pkgs.jq}/bin/jq -r '.[] | select(.focused).name' | awk '{print ($1 + 8) % 10 + 1}')";
      in {
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        "${modifier}+Right" = "exec swaymsg workspace ${next}";
        "${modifier}+Left" = "exec swaymsg workspace ${previous}";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

        "${modifier}+Shift+Right" = "exec swaymsg move container to workspace ${next}";
        "${modifier}+Shift+Left" = "exec swaymsg move container to workspace ${previous}";

        "${modifier}+Mod1+Right" = "exec swaymsg move container to workspace ${next}; exec swaymsg workspace ${next}";
        "${modifier}+Mod1+Left" = "exec swaymsg move container to workspace ${previous}; exec swaymsg workspace ${previous}";

        "${modifier}+minus" = "scratchpad show";
        "${modifier}+Shift+minus" = "move scratchpad";

        "${modifier}+${left}" = "focus left";
        "${modifier}+${down}" = "focus down";
        "${modifier}+${up}" = "focus up";
        "${modifier}+${right}" = "focus right";

        "${modifier}+Shift+${left}" = "move left";
        "${modifier}+Shift+${down}" = "move down";
        "${modifier}+Shift+${up}" = "move up";
        "${modifier}+Shift+${right}" = "move right";

        "${modifier}+t" = "layout tabbed";
        "${modifier}+s" = "layout toggle split";
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+a" = "focus parent";

        "${modifier}+Shift+Space" = "floating toggle";
        "${modifier}+Space" = "focus mode_toggle";

        "${modifier}+r" = "mode resize";

        "${modifier}+w" = "kill";

        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+x" = "exec wlogout";
        "${modifier}+d" = "exec ${menu}";

        XF86AudioMute = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        XF86AudioLowerVolume = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1 && wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}' > /tmp/wob.sock";
        XF86AudioRaiseVolume = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1 && wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}' > /tmp/wob.sock";
        XF86AudioMicMute = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        XF86MonBrightnessUp = "exec brightnessctl set 1%+| sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /tmp/wob.sock";
        XF86MonBrightnessDown = "exec brightnessctl set 1%- | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > /tmp/wob.sock";
      };
      floating = {
        titlebar = false;
        border = 2;
        inherit modifier;
        criteria = [
          {window_role = "popup";}
          {window_role = "bubble";}
          {window_role = "task_dialog";}
          {window_type = "dialog";}
          {window_type = "menu";}
        ];
      };
      gaps = {
        inner = 8;
        outer = 8;
      };
      bars = [
        # {
        #   position = "top";
        #   fonts = {
        #     names = ["Monocraft"];
        #     style = "Regular";
        #     size = 12.0;
        #   };
        #   statusCommand = "${statusCommand}";
        #   extraConfig = "gaps 8";
        # }
      ];
    };
  };

  programs.eww = {
    enable = true;
    package = pkgs.eww;
    configDir = ./eww;
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
      PartOf = lib.mkDefault target;
      BindsTo = lib.mkDefault target;
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

  xdg.configFile."wob/wob.ini".text = with (import ../../../themes/stargaze.nix {mode = "dark";}); ''
    timeout = 1000
    max = 100
    width = 627
    height = 16

    border_offset = 1
    border_size = 1
    bar_padding = 1

    anchor = bottom

    background_color = ${bg}
    border_color = ${primary}
    bar_color = ${primary}
  '';

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
