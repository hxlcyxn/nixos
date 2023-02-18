{pkgs, ...}: let
  theme = import ../../../themes/stargaze.nix {mode = "light";};
in {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = false;
      hidpi = false;
    };
    extraConfig = ''
      $term=${pkgs.foot}/bin/foot
      $browser=${pkgs.firefox}bin/firefox
      $filemanager=${pkgs.gnome.nautilus}/bin/nautilus
      $launcher=${pkgs.rofi-wayland}/bin/rofi -show drun

      general {
        gaps_in=8
        gaps_out=16
        border_size=1
        col.active_border=rgba(${theme.active}ff)
        col.inactive_border=rgba(${theme.inactive}ff)
      }
      decoration {
        rounding=4
        multisample_edges=true
        blur=true
        blur_size=8
        blur_passes=1
        drop_shadow=true
        shadow_range=4
        shadow_render_power=2
        col.shadow=rgba(${theme.black}11)
        shadow_offset=-12 -12
      }
      animations {
        enabled=true
        bezier=overshot,0,0.61,0.22,1.12
        animation=windows,1,3.8,overshot,popin
      }
      input {
        kb_layout=de
        kb_variant=nodeadkeys
        touchpad {
          disable_while_typing=true
          tap-to-click=true
        }
      }
      gestures {
        workspace_swipe=true
      }
      misc {
        enable_swallow=true
        swallow_regex=^(foot)$
      }

      windowrule=float,Rofi

      bind=SUPER,Return,exec,$term
      bind=SUPER,w,exec,$browser
      bind=SUPER,f,exec,$filemanager
      bind=SUPER,Space,exec,$launcher

      bindm=SUPER,mouse:272,movewindow
      bindm=SUPER,mouse:273,resizewindow
      bind=SUPER,Q,killactive
      bind=SUPERSHIFT,SPACE,togglefloating
      bind=SUPERSHIFT,f,fullscreen

      bind=SUPER,left,movefocus,l
      bind=SUPER,right,movefocus,r
      bind=SUPER,up,movefocus,u
      bind=SUPER,down,movefocus,d

      bind=SUPER,1,workspace,1
      bind=SUPER,2,workspace,2
      bind=SUPER,3,workspace,3
      bind=SUPER,4,workspace,4
      bind=SUPER,5,workspace,5
      bind=SUPER,6,workspace,6
      bind=SUPER,7,workspace,7
      bind=SUPER,8,workspace,8
      bind=SUPER,9,workspace,9
      bind=SUPER,0,workspace,10
      bind=SUPERSHIFT,1,movetoworkspace,1
      bind=SUPERSHIFT,2,movetoworkspace,2
      bind=SUPERSHIFT,3,movetoworkspace,3
      bind=SUPERSHIFT,4,movetoworkspace,4
      bind=SUPERSHIFT,5,movetoworkspace,5
      bind=SUPERSHIFT,6,movetoworkspace,6
      bind=SUPERSHIFT,7,movetoworkspace,7
      bind=SUPERSHIFT,8,movetoworkspace,8
      bind=SUPERSHIFT,9,movetoworkspace,9
      bind=SUPERSHIFT,0,movetoworkspace,10

      bind=,XF86AudioRaiseVolume,exec,${pkgs.pamixer}/bin/pamixer -i 3
      bind=,XF86AudioLowerVolume,exec,${pkgs.pamixer}/bin/pamixer -d 3
      bind=,XF86AudioMute,exec,${pkgs.pamixer}/bin/pamixer -t
      bind=,XF86MonBrightnessUp,exec,${pkgs.brightnessctl}/bin/brightnessctl s +5%
      bind=,XF86MonBrightnessDown,exec,${pkgs.brightnessctl}/bin/brightnessctl s 5%-
      bind=,XF86AudioMedia,exec,${pkgs.playerctl}/bin/playerctl play-pause
      bind=,XF86AudioPlay,exec,${pkgs.playerctl}/bin/playerctl play-pause
      bind=,XF86AudioStop,exec,${pkgs.playerctl}/bin/playerctl stop
    '';
  };
}
