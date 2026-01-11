{
  pkgs,
  lib,
  ...
}: let
  iniFormat = pkgs.formats.ini {};
in {
  #########################
  # KeePassXC config (INI)
  #########################
  # Writes: ~/.config/keepassxc/keepassxc.ini
  xdg.configFile."keepassxc/keepassxc.ini".source = iniFormat.generate "keepassxc.ini" {
    Browser = {
      Enabled = "true"; # use string "true" instead of Nix boolean true

      # Optional nice defaults:
      # SearchInAllDatabases = "true";
      # MatchURLScheme = "true";
    };

    # Optional Secret Service integration:
    # FdoSecrets = {
    #   Enabled = "true";
    # };
  };

  #########################
  # Install + dirs + autostart + activation hooks
  #########################
  home = {
    packages = [
      pkgs.keepassxc
    ];

    # Ensure directory exists for KeePassXC config
    activation.createKeepassxcDir = lib.hm.dag.entryBefore ["writeBoundary"] ''
      mkdir -p "$HOME/.config/keepassxc"
    '';

    # Creates: ~/.config/autostart/keepassxc.desktop
    file.".config/autostart/keepassxc.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Version=1.0
      Name=KeePassXC
      Comment=Password Manager
      Exec=keepassxc
      Terminal=false
      X-GNOME-Autostart-enabled=true
    '';

    # Librewolf native-messaging bridge
    # Create (or update) a symlink:
    #   ~/.librewolf/native-messaging-hosts -> ~/.mozilla/native-messaging-hosts
    activation.librewolfKeePassSymlink = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME/.librewolf"
      mkdir -p "$HOME/.mozilla/native-messaging-hosts"
      ln -sfn "$HOME/.mozilla/native-messaging-hosts" \
              "$HOME/.librewolf/native-messaging-hosts"
    '';
  };
}
