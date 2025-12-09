{ config, pkgs, lib, ... }:

let
  mod = "Mod4";  # Super
  toString = builtins.toString;
in
{
  #############################
  # Sway WM
  #############################
  wayland.windowManager.sway = {
    enable = true;

    # Required so that systemd user services inherit WAYLAND_DISPLAY etc.
    wrapperFeatures.gtk = true;
    systemd.enable = true;
    systemd.variables = [ "--all" ];

    config = {
      modifier = mod;

      terminal = "${pkgs.kitty}/bin/kitty";

      # Use rofi-wayland as the default menu (Mod+d)
      menu     = "${pkgs.rofi-wayland}/bin/rofi -show drun";

      ##################################
      # Input devices
      ##################################
      input = {
        "type:keyboard" = {
          xkb_layout  = "us,tr";
          xkb_options = "grp:alt_shift_toggle";
        };
      };

      ##################################
      # Keybindings
      ##################################
      keybindings =
        let
          mkWS = num:
            let n = toString num;
            in {
              "${mod}+${n}"       = "workspace number ${n}";
              "${mod}+Shift+${n}" = "move container to workspace number ${n}";
            };
        in
          mkWS 1 // mkWS 2 // mkWS 3 // mkWS 4 // mkWS 5 // mkWS 6 // mkWS 7
          //
          {
            # Apps
            "${mod}+t" = "exec ${pkgs.kitty}/bin/kitty";

            # Explicit rofi-wayland launcher on Mod+r
            "${mod}+r" = "exec ${pkgs.rofi-wayland}/bin/rofi -show drun";

            "${mod}+f" = "exec ${pkgs.librewolf}/bin/librewolf";

            # Window management
            "${mod}+q"       = "kill";
            "${mod}+Shift+c" = "reload";
            "${mod}+Shift+e" = "exit";

            # Screen lock
            "${mod}+l" =
              "exec ${pkgs.swaylock-effects}/bin/swaylock -f -c 000000";

            # Screenshot (region → file + clipboard)
            "${mod}+p" =
              "exec ${pkgs.bash}/bin/sh -c 'FILE=\"$HOME/Pictures/ScreenShots/screenshot-$(date +%Y-%m-%d-%H%M%S).png\"; ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" \"$FILE\"; ${pkgs.wl-clipboard}/bin/wl-copy < \"$FILE\"'";

            # Output navigation
            "${mod}+a"        = "focus output left";
            "${mod}+d"        = "focus output right";
            "${mod}+Shift+a"  = "move container to output left";
            "${mod}+Shift+d"  = "move container to output right";

            ##################################
            # Hardware keys: audio, media, brightness
            ##################################

            # Volume (speaker)
            "XF86AudioMute"        = "exec ${pkgs.pamixer}/bin/pamixer -t";
            "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 5";
            "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 5";

            "F10"                  = "exec ${pkgs.pamixer}/bin/pamixer -t";
            "F11"                  = "exec ${pkgs.pamixer}/bin/pamixer -d 5";
            "F12"                  = "exec ${pkgs.pamixer}/bin/pamixer -i 5";

            # Microphone mute toggle
            "XF86AudioMicMute"     = "exec ${pkgs.pamixer}/bin/pamixer --default-source -t";

            # Media control
            "XF86AudioPlay"        = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
            "XF86AudioPause"       = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
            "XF86AudioNext"        = "exec ${pkgs.playerctl}/bin/playerctl next";
            "XF86AudioPrev"        = "exec ${pkgs.playerctl}/bin/playerctl previous";

            # Brightness control
            "XF86MonBrightnessUp"   = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
            "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          };

      ##################################
      # Outputs (monitors)
      ##################################
      output = {
        "HDMI-A-1" = {
          mode  = "2560x1440@143.93Hz";
          pos   = "1920 0";   # Placed to the right of eDP-1
          scale = "1";
        };

        "eDP-1" = {
          mode  = "1920x1080@60Hz";
          pos   = "0 0";      # Laptop screen at (0,0)
          scale = "1";
        };
      };

      ##################################
      # (you can add bars, gaps, etc. here later)
      ##################################
    };
  };

  #############################
  # Packages
  #############################
  home.packages = with pkgs; [
    kitty
    rofi-wayland
    grim
    slurp
    wl-clipboard
    swaylock-effects

    pamixer
    brightnessctl
    playerctl
  ];

  #############################
  # Environment variables
  #############################
  home.sessionVariables = {
    GTK_USE_PORTAL      = "1";  # better GTK behaviour on Wayland
    MOZ_ENABLE_WAYLAND  = "1";  # Firefox/Librewolf Wayland support
    QT_QPA_PLATFORM     = "wayland";  # Qt apps on Wayland
  };
}
