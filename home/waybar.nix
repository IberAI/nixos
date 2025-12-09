{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };

    settings = {
      mainBar = {
        layer     = "top";
        position  = "top";
        height    = 28;

        modules-left   = [ "sway/workspaces" ];
        modules-center = [ "clock" ];
        modules-right  = [ "cpu" "memory" "network" "battery" ];

        "sway/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };

        clock = { format = "{:%Y-%m-%d %H:%M}"; };

        cpu = { format = "CPU {usage}%"; interval = 2; };
        memory = { format = "RAM {used:0.1f}G/{total:0.1f}G"; interval = 2; };

        network = {
          interval = 5;
          format-ethernet     = "Ethernet: {ifname}";
          format-wifi         = "Wi-Fi: {essid} {signalStrength}%";
          format-disconnected = "Network: Disconnected";
        };

        battery = {
          bat      = "BAT0";
          adapter  = "AC";
          interval = 30;
          states   = { warning = 30; critical = 15; };

          # Default / fallback
          format = "{capacity}%";

          # Different text per state
          format-charging    = "{capacity}% charging";
          format-discharging = "{capacity}% discharging";
          format-full        = "{capacity}% full";
          format-plugged     = "{capacity}% plugged";
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
      #clock,#cpu,#memory,#network,#battery,#workspaces button {
        padding: 0 6px;
      }
      #workspaces button.focused {
        color: #ffffff;
        border-bottom: 2px solid #ffffff;
      }
    '';
  };
}

