{ config, pkgs, lib, ... }:

let
  mod = "Mod4";                    # Super
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
      menu     = "${pkgs.rofi}/bin/rofi -show drun";

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
            "${mod}+r" = "exec ${pkgs.rofi}/bin/rofi -show drun";
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
      # Autostart
      ##################################
    };
  };

  #############################
  # Packages
  #############################
  home.packages = with pkgs; [
    kitty
    rofi
    grim
    slurp
    wl-clipboard
    swaylock-effects
  ];

  #############################
  # Environment variables
  #############################
  home.sessionVariables = {
    GTK_USE_PORTAL = "1";  # better GTK behaviour on Wayland
    MOZ_ENABLE_WAYLAND = "1";  # Firefox/Librewolf Wayland support
    QT_QPA_PLATFORM = "wayland";  # Qt apps on Wayland
  };
}

