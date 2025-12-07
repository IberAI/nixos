{
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      logo = {
        type = "auto";
        source = "nix";
        padding = {
          top = 2;
          left = 3;
        };
      };

      modules = [
        "break"
        {
          type = "custom";
          format = "┌──────────────────────Hardware──────────────────────┐";
        }
        {
          type = "host";
          key = "│ ├PC";
          keyColor = "green";
        }
        {
          type = "cpu";
          key = "│ ├";
          keyColor = "green";
        }
        {
          type = "gpu";
          key = "│ ├󰍛";
          keyColor = "green";
        }
        {
          type = "memory";
          key = "│ ├󰍛";
          keyColor = "green";
        }
        {
          type = "disk";
          key = "│ ├";
          keyColor = "green";
        }
        {
          type = "localip";
          key = "│ └󰲝";
          keyColor = "green";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "custom";
          keyColor = "yellow";
          format = "┌──────────────────────Software──────────────────────┐";
        }
        {
          type = "os";
          key = "│ ├OS";
          keyColor = "yellow";
        }
        {
          type = "kernel";
          key = "│ ├";
          keyColor = "yellow";
        }
        {
          type = "bios";
          key = "│ ├";
          keyColor = "yellow";
        }
        {
          type = "packages";
          key = "│ ├󰏖";
          keyColor = "yellow";
        }
        {
          type = "shell";
          key = "│ ├";
          keyColor = "yellow";
        }
        {
          type = "lm";
          key = "│ ├";
          keyColor = "yellow";
        }
        {
          type = "wm";
          key = "│ ├";
          keyColor = "yellow";
        }
        {
          type = "wmtheme";
          key = "│ ├󰉼";
          keyColor = "yellow";
        }
        {
          type = "terminal";
          key = "│ └";
          keyColor = "yellow";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "custom";
          format = "┌──────────────────────Chronology────────────────────┐";
        }
        {
          type = "command";
          key = "│ ├OS Age   ";
          keyColor = "magenta";
          text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
        }
        {
          type = "uptime";
          key = "│ ├Uptime   ";
          keyColor = "magenta";
        }
        {
          type = "datetime";
          key = "│ ├Date     ";
          keyColor = "magenta";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }

        {
          type = "colors";
          paddingLeft = 0;
          symbol = "star";
        }
      ];
    };
  };
}
