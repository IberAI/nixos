{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;

        modules-left   = [ "sway/workspaces" ];
        modules-center = [ "clock" "window" ];
        modules-right  = [ "cpu" "memory" "network" "battery" ];

        "sway/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "{:%A, %d %B %Y}";
        };

        window = {
          format = "Focused: {title}";
          tooltip-format = "Focused window: {title}";
        };

        cpu = {
          format = "CPU {usage}%";
        };

        memory = {
          format = "RAM {used:0.1f}G/{total:0.1f}G";
        };

        network = {
          format-wifi         = "Wi-Fi: {essid} {signalStrength}%";
          format-ethernet     = "Ethernet: {ifname}";
          format-disconnected = "Network: Disconnected";
        };

        battery = {
          format           = "Battery: {percentage}%";
          format-charging  = "Battery: {percentage}% (Charging)";
          format-plugged   = "Battery: {percentage}% (Plugged In)";
          states = {
            warning  = 30;
            critical = 15;
          };
        };
      };
    };

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

