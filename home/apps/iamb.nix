{
  config,
  pkgs,
  lib,
  ...
}: {
  #########################
  # iamb (Matrix TUI) config
  #########################
  # Home Manager will generate:
  #   ~/.config/iamb/config.toml
  # via programs.iamb.settings
  #
  # Docs:
  # - Config reference: https://iamb.chat/configure.html
  # - E2EE verify/keys: https://iamb.chat/e2ee/
  programs.iamb = {
    enable = true;

    settings = {
      # You can name this whatever you want; "main" is a good default
      default_profile = "main";

      profiles.main = {
        user_id = "@iber:5dlawr4ojnt3x6jkobmrijorrutetyduy2jrswi2fqusfcdllwnpelyd.onion";
        url = "http://5dlawr4ojnt3x6jkobmrijorrutetyduy2jrswi2fqusfcdllwnpelyd.onion";
      };

      # iamb behavior defaults
      settings = {
        # Helps on slow networks / large first syncs
        request_timeout = 180;

        # Show names nicely (valid: "username" | "localpart" | "displayname")
        username_display = "displayname";

        # Typical “feels like a normal messenger” behavior
        read_receipt_display = true;
        read_receipt_send = true;
        typing_notice_display = true;
        typing_notice_send = true;

        # Uncomment for troubleshooting:
        # log_level = "debug";
      };

      # Optional: keep downloads organized
      dirs = {
        downloads = "${config.home.homeDirectory}/Downloads/iamb";
      };

      # Optional: image previews (only enable if you use a supported terminal)
      # See: https://iamb.chat/terminals.html
      settings.image_preview = {
        protocol = {type = "kitty";};
      };
    };
  };

  #########################
  # Dirs / activation helpers
  #########################
  home.activation.createIambDirs = lib.hm.dag.entryBefore ["writeBoundary"] ''
    mkdir -p "$HOME/.config/iamb"
    mkdir -p "$HOME/Downloads/iamb"
    # Handy place for E2EE key exports (optional):
    mkdir -p "$HOME/Passwords/Matrix"
  '';

  #########################
  # Install extras (optional)
  #########################
  # iamb itself is installed by programs.iamb.enable.
  # Add extra helpful tools here if you want them available:
  home.packages = with pkgs; [
    # e.g. for opening links from terminal
    xdg-utils
  ];
}
