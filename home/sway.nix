{ config, pkgs, lib, ... }:

let
  mod = "Mod4";                    # Super / Win key
  toString = builtins.toString;
in
{
  # NOTE: keep `home.stateVersion` in your main home.nix, not here.

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;    # GTK env for Wayland apps

    # Make systemd user services inherit Sway/Wayland env vars
    systemd.enable = true;
    systemd.variables = [ "--all" ];

    config = {
      modifier = mod;

      # Defaults used by some sway configs / bars
      terminal = "${pkgs.kitty}/bin/kitty";
      menu     = "${pkgs.rofi}/bin/rofi -show drun";

      ########################
      # Input: keyboard layout
      ########################
      input = {
        "type:keyboard" = {
          # US + Turkish, toggle with Alt+Shift
          xkb_layout  = "us,tr";
          xkb_options = "grp:alt_shift_toggle";
        };
      };

      ########################
      # Keybindings
      ########################
      keybindings =
        let
          # Standard workspaces 1–7
          mkWS = num:
            let n = toString num;
            in {
              "${mod}+${n}"       = "workspace number ${n}";
              "${mod}+Shift+${n}" = "move container to workspace number ${n}";
            };
        in
          mkWS 1
          // mkWS 2
          // mkWS 3
          // mkWS 4
          // mkWS 5
          // mkWS 6
          // mkWS 7
          // {
            # Apps
            "${mod}+t" = "exec ${pkgs.kitty}/bin/kitty";              # terminal
            "${mod}+r"      = "exec ${pkgs.rofi}/bin/rofi -show drun";     # launcher
            "${mod}+f"      = "exec ${pkgs.librewolf}/bin/librewolf";      # browser

            # Window management
            "${mod}+q"       = "kill";         # close window
            "${mod}+Shift+c" = "reload";       # reload Sway config
            "${mod}+Shift+e" = "exit";         # exit Sway

            # Screen lock (Win+L)
            "${mod}+l" =
              "exec ${pkgs.swaylock-effects}/bin/swaylock -f -c 000000";

            # Screenshot (region) -> file + clipboard
            "${mod}+p" =
  "exec ${pkgs.bash}/bin/bash -lc '${pkgs.grim}/bin/grim -g \"${"$"}(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.coreutils}/bin/tee \"${"$"}HOME/Pictures/ScreenShots/screenshot-$(${pkgs.coreutils}/bin/date +%Y-%m-%d-%H%M%S).png\" | ${pkgs.wl-clipboard}/bin/wl-copy --type image/png'";


            # Move focus between outputs / move containers between outputs
            "${mod}+a"        = "focus output left";
            "${mod}+d"        = "focus output right";
            "${mod}+Shift+a"  = "move container to output left";
            "${mod}+Shift+d"  = "move container to output right";
          };

      ########################
      # Outputs (monitors)
      ########################
      # Adjust output names if `swaymsg -t get_outputs` shows different IDs.
      output = {
        "HDMI-A-1" = {
          # LG UltraGear 144 Hz, 2560x1440, primary at (0,0)
          mode  = "2560x1440@143.93Hz";
          pos   = "2560 0";
          scale = "1";
        };

        "eDP-1" = {
          # Laptop panel 1080p, to the left of the external monitor
          mode  = "1920x1080@60Hz";
          pos   = "0 0";
          scale = "1";
        };
      };

      ########################
      # Autostart
      ########################
      # (add apps here later if you want)
    };
  };

  ########################
  # Sway-related packages
  ########################
  home.packages = with pkgs; [
    kitty             # terminal
    rofi              # launcher
    grim              # screenshots
    slurp             # region selector for grim
    wl-clipboard      # wl-copy / wl-paste
    swaylock-effects  # screen locker used by Win+L
  ];

  ########################
  # Session env
  ########################
  home.sessionVariables = {
    GTK_USE_PORTAL = "1";  # better GTK behaviour on Wayland
  };
}

