{ pkgs, ... }:

let
  batteryNotify = pkgs.writeShellApplication {
    name = "battery-notify";
    # No libnotify: use dunstify from dunst
    runtimeInputs = [ pkgs.coreutils pkgs.dunst ];
    text = builtins.readFile ./scripts/battery-notify.sh;
  };
in
{
  # Recommended so HM starts/stops user units declaratively on switch
  systemd.user.startServices = "sd-switch";

  # Make sure dunst is actually running (otherwise no notifications)
  services.dunst.enable = true;

  systemd.user.services.battery-notify = {
    Unit = {
      Description = "Battery threshold notifications (20% / 80%)";
      After = [ "graphical-session.target" "dunst.service" ];
      Wants = [ "graphical-session.target" "dunst.service" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${batteryNotify}/bin/battery-notify";
    };

  };

  systemd.user.timers.battery-notify = {
    Unit.Description = "Check battery thresholds";
    Timer = {
      Unit = "battery-notify.service";
      OnBootSec = "1m";
      OnUnitActiveSec = "2m";
      AccuracySec = "30s";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
