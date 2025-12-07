{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    # Start Waybar automatically under sway-session
    systemd = {
      enable = true;
      target = "sway-session.target";
    };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;

        modules-left   = [ "sway/workspaces" ];
        modules-center = [ "clock" "window" ];
        modules-right  = [ "cpu" "memory" "network" "battery" ];

        #############################################
        # WORKSPACES
        #############################################
        "sway/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };

        #############################################
        # CLOCK
        #############################################
        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "{:%A, %d %B %Y}";
        };

        #############################################
        # FOCUSED WINDOW
        #############################################
        window = {
          format = "  {title}";
          tooltip-format = "Focused window: {title}";
        };

        #############################################
        # CPU
        #############################################
        cpu = {
          format = "CPU {usage}%";
          interval = 2;
        };

        #############################################
        # MEMORY
        #############################################
        memory = {
          format = "RAM {used:0.1f}G/{total:0.1f}G";
          interval = 2;
        };

        #############################################
        # NETWORK
        #############################################
        network = {
          interval = 3;
          format-wifi         = "  {essid} {signalStrength}%";
          format-ethernet     = "  {ifname}";
          format-disconnected = "󰤭  Offline";
        };

        #############################################
        # BATTERY  (your device: BAT0, AC)
        #############################################
        battery = {
          bat = "BAT0";
          adapter = "AC";

          interval = 5;

          # Icons from Nerd Fonts
          format = "󰁹  {percentage}%";
          format-charging  = "󰂄  {percentage}%";
          format-plugged   = "  {percentage}%";

          states = {
            warning  = 30;
            critical = 15;
          };
        };
      };
    };

    #############################################
    # CSS STYLE
    #############################################
    style = ''
      * {
        font-family: "DejaVu Sans Mono", monospace;
        font-size: 11px;
      }

      window#waybar {
        background: rgba(0,0,0,0.85);
        color: #ffffff;
      }

      #workspaces button {
        padding: 0 6px;
        color: #aaaaaa;
      }

      #workspaces button.focused {
        color: #ffffff;
        border-bottom: 2px solid #ffffff;
      }

      #clock,
      #cpu,
      #memory,
      #network,
      #battery,
      #window {
        padding: 0 8px;
      }

      #window {
        margin-left: 10px;
      }
    '';
  };
}

