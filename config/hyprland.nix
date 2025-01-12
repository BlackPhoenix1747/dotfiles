{
  lib,
  username,
  host,
  inputs,
  pkgs,
  config,
  ...
}:

let
  hyprplugins = inputs.hyprland-plugins.packages.${pkgs.system};
  inherit (import ../hosts/${host}/variables.nix)
    browser
    terminal
    extraMonitorSettings
    ;
in
with lib;
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    # plugins = [
    #   hyprplugins.hyprtrails
    # ];
    extraConfig =
      let
        modifier = "SUPER";
      in
      concatStrings [
        ''
          #env = NIXOS_OZONE_WL, 1
          env = NIXPKGS_ALLOW_UNFREE, 1
          env = XDG_CURRENT_DESKTOP, Hyprland
          env = XDG_SESSION_TYPE, wayland
          env = XDG_SESSION_DESKTOP, Hyprland
          env = GDK_BACKEND, wayland, x11
          env = CLUTTER_BACKEND, wayland
          env = QT_QPA_PLATFORM=wayland;xcb
          env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
          env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
          env = SDL_VIDEODRIVER, x11
          env = MOZ_ENABLE_WAYLAND, 1
          exec-once = dbus-update-activation-environment --systemd --all
          exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          exec-once = killall -q swww;sleep .5 && swww init
          # exec-once = killall -q waybar;sleep .5 && waybar
          exec-once = killall -q swaync;sleep .5 && swaync
          exec-once = nm-applet --indicator
          exec-once = blueman-applet
          exec-once = lxqt-policykit-agent
          exec-once = sleep 1.5 && swww img /home/${username}/Pictures/Wallpapers/law.jpg
          exec-once = playerctld daemon
          exec-once = mpDris2
          exec-once = wl-paste --type text --watch cliphist store
          exec-once = wl-paste --type image --watch cliphist store
          exec-once = battery & disown


          ${extraMonitorSettings}
          general {
            gaps_in = 6
            gaps_out = 8
            border_size = 2
            layout = dwindle
            resize_on_border = true
            col.active_border = rgb(${config.stylix.base16Scheme.base08}) rgb(${config.stylix.base16Scheme.base0C}) 45deg
            col.inactive_border = rgb(${config.stylix.base16Scheme.base01})
          }
          input {
            kb_layout = us
            kb_options = grp:alt_shift_toggle
            follow_mouse = 3
            touchpad {
              natural_scroll = false
            }
            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
            accel_profile = flat
          }
          windowrule = noborder,^(wofi)$
          windowrule = center,^(wofi)$
          windowrule = center,^(steam)$
          windowrule = float, nm-connection-editor|blueman-manager
          windowrule = float, swayimg|vlc|Viewnior|pavucontrol
          windowrule = float, nwg-look|qt5ct
          windowrule = float, zoom
          windowrulev2 = float,class:(xdg-desktop-portal-gtk)
          windowrulev2 = stayfocused, title:^()$,class:^(steam)$
          windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$
          windowrulev2 = opacity 0.9 0.7, class:^(firefox)$
          windowrulev2 = opacity 0.9 0.7, class:^(thunar)$
          #windowrulev2 = workspace 1,class:(Vivaldi-stable)
          windowrulev2 = workspace 1,class:(firefox)
          windowrulev2 = workspace 2,class:(kitty)
          #windowrulev2 = workspace 3,class:(discord)
          windowrulev2 = workspace 3,class:(vesktop)
          windowrulev2 = workspace 9,class:(calibre-gui)
          windowrulev2 = workspace 9,class:(org.kde.okular)
          windowrulev2 = workspace 5,class:(mpv)
          #windowrulev2 = workspace 8,class:(com.obsproject.Studio)
          windowrulev2 = workspace 4,class:(spotube)
          windowrulev2 = workspace 4,class:(Spotify)
          windowrulev2 = workspace 10,class:(Ryujinx)
          windowrulev2 = workspace 10,class:(steam)
          windowrulev2 = workspace 10,class:(lutris)
          windowrulev2 = pin,title:(Picture in picture)
          windowrulev2 = immediate,class:(steam_app_0)

          gestures {
            workspace_swipe = true
            workspace_swipe_fingers = 3
          }
          misc {
            initial_workspace_tracking = 0
            mouse_move_enables_dpms = true
            key_press_enables_dpms = true
          }
          animations {
            enabled = yes
            bezier = wind, 0.05, 0.9, 0.1, 1.05
            bezier = winIn, 0.1, 1.1, 0.1, 1.1
            bezier = winOut, 0.3, -0.3, 0, 1
            bezier = liner, 1, 1, 1, 1
            animation = windows, 1, 6, wind, slide
            animation = windowsIn, 1, 6, winIn, slide
            animation = windowsOut, 1, 5, winOut, slide
            animation = windowsMove, 1, 5, wind, slide
            animation = border, 1, 1, liner
            animation = fade, 1, 10, default
            animation = workspaces, 1, 5, wind
          }
          decoration {
            rounding = 10
            shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
            }
            blur {
                enabled = true size = 5
                passes = 3
                new_optimizations = on
                ignore_opacity = off
            }
          }
          plugin {
            hyprtrails {
            }
          }
          dwindle {
            pseudotile = true
            preserve_split = true
          }
          binds {
            allow_workspace_cycles = true
            workspace_back_and_forth = true
          }
          bind = ${modifier},Return,exec,${terminal}
          bind = ${modifier}SHIFT,Return,exec,rofi-launcher
          bind = ${modifier}SHIFT,W,exec,web-search
          bind = ${modifier}ALT,W,exec,wallsetter
          bind = ${modifier}SHIFT,N,exec,swaync-client -rs
          bind = ${modifier},W,exec,${browser}
          bind = ${modifier},E,exec,emopicker9000
          bind = ,Print,exec,screenshootin
          bind = ${modifier},D,exec,vesktop
          bind = ${modifier},O,exec,obsidian
          bind = ${modifier},C,exec,hyprpicker -a
          bind = ${modifier},G,exec,flatpak run net.lutris.Lutris 
          bind = ${modifier},N,exec,thunar
          bind = ${modifier},M,exec,spotify
          bind = ,F10,exec,jerry --rofi
          bind = ${modifier},V,exec,cliphist list | rofi -dmenu | cliphist decode | wl-copy
          bind = ${modifier},Q,killactive,
          bind = ${modifier},P,pseudo,
          bind = ${modifier}SHIFT,I,togglesplit,
          bind = ${modifier},F,fullscreen,
          bind = ${modifier}SHIFT,F,togglefloating,
          bind = ${modifier}SHIFT,C,exit,
          bind = ${modifier}SHIFT,left,movewindow,l
          bind = ${modifier}SHIFT,right,movewindow,r
          bind = ${modifier}SHIFT,up,movewindow,u
          bind = ${modifier}SHIFT,down,movewindow,d
          bind = ${modifier}SHIFT,h,movewindow,l
          bind = ${modifier}SHIFT,l,movewindow,r
          bind = ${modifier}SHIFT,k,movewindow,u
          bind = ${modifier}SHIFT,j,movewindow,d
          bind = ${modifier},left,movefocus,l
          bind = ${modifier},right,movefocus,r
          bind = ${modifier},up,movefocus,u
          bind = ${modifier},down,movefocus,d
          bind = ${modifier},h,movefocus,l
          bind = ${modifier},l,movefocus,r
          bind = ${modifier},k,movefocus,u
          bind = ${modifier},j,movefocus,d
          bind = ${modifier},1,workspace,1
          bind = ${modifier},2,workspace,2
          bind = ${modifier},3,workspace,3
          bind = ${modifier},4,workspace,4
          bind = ${modifier},5,workspace,5
          bind = ${modifier},6,workspace,6
          bind = ${modifier},7,workspace,7
          bind = ${modifier},8,workspace,8
          bind = ${modifier},9,workspace,9
          bind = ${modifier},0,workspace,10
          bind = ${modifier}SHIFT,T,movetoworkspace,special
          bind = ${modifier},T,togglespecialworkspace
          bind = ${modifier}SHIFT,1,movetoworkspace,1
          bind = ${modifier}SHIFT,2,movetoworkspace,2
          bind = ${modifier}SHIFT,3,movetoworkspace,3
          bind = ${modifier}SHIFT,4,movetoworkspace,4
          bind = ${modifier}SHIFT,5,movetoworkspace,5
          bind = ${modifier}SHIFT,6,movetoworkspace,6
          bind = ${modifier}SHIFT,7,movetoworkspace,7
          bind = ${modifier}SHIFT,8,movetoworkspace,8
          bind = ${modifier}SHIFT,9,movetoworkspace,9
          bind = ${modifier}SHIFT,0,movetoworkspace,10
          bind = ${modifier}CONTROL,right,workspace,e+1
          bind = ${modifier}CONTROL,left,workspace,e-1
          bind = ${modifier},mouse_down,workspace, e+1
          bind = ${modifier},mouse_up,workspace, e-1
          bindm = ${modifier},mouse:272,movewindow
          bindm = ${modifier},mouse:273,resizewindow
          bind = ALT,Tab,cyclenext
          bind = ALT,Tab,bringactivetotop
          binde = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
          binde = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          bind = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          bind = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle
          bind = ,XF86AudioPlay, exec, playerctl play-pause
          bind = ,XF86AudioPause, exec, playerctl play-pause
          bind = ,XF86AudioNext, exec, playerctl next
          bind = ,XF86AudioPrev, exec, playerctl previous
          binde = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
          binde = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
          # trigger when the switch is turning off
          bindl = , switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1, 1366x768, 0x0, 1"
          # trigger when the switch is turning on
          bindl = , switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1, disable"
        ''
      ];
  };
}
