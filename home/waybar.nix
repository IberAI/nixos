{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    # Use systemd managed Waybar (recommended for Sway+systemd)
    systemd = {
      enable = true;
      target = "sway-session.target";
      after = [ "sway-session.target" ];
    };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;

        modules-left   = [ "sway/workspaces" ];
        modules-center = [ "clock" "window" ];
        modules-right  = [ "cpu" "memory" "network" "battery" ];

        ###############################
        # WORKSPACES
        ###############################
        "sway/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };

        ###############################
        # CLOCK
        ###############################
        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "{:%A, %d %B %Y}";
        };

        ###############################
        # FOCUSED WINDOW
        ###############################
        window = {
          format = "  {title}";
          tooltip-format = "Focused: {title}";
        };

        ###############################
        # CPU
        ###############################
        cpu = {
          format = "CPU {usage}%";
          interval = 3;
        };

        ###############################
        # MEMORY
        ###############################
        memory = {
          format = "RAM {used:0.1f}G/{total:0.1f}G";
          interval = 3;
        };

        ###############################
        # NETWORK
        ###############################
        network = {
          interval = 5;
          format-wifi         = "  {essid} {signalStrength}%";
          format-ethernet     = "  {ifname}";
          format-disconnected = "󰤭  Offline";
        };

        ###############################
        # BATTERY  (FIXED & RELIABLE)
        ###############################
        battery = {
          # Change these if needed:
          bat = "BAT0";        # ← your battery name
          adapter = "AC";      # ← your AC adapter name

          interval = 5;
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

    ########################################
    # CSS styling
    ########################################
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

      #window { margin-left: 10px; }
    '';
  };
}

