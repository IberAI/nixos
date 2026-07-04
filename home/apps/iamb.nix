{
  config,
  pkgs,
  lib,
  ...
}:
{
  home = {
    activation.createIambDirs = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/iamb"
      mkdir -p "$HOME/Downloads/iamb"
      mkdir -p "$HOME/Passwords/Matrix"
    '';

    activation.iambPrivateConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      matrix_user=/run/secrets/matrix/userId
      matrix_homeserver=/run/secrets/matrix/homeserver
      target="$HOME/.config/iamb/config.toml"

      if [ -r "$matrix_user" ] && [ -r "$matrix_homeserver" ]; then
        mkdir -p "$HOME/.config/iamb"
        {
          printf 'default_profile = "main"\n\n'
          printf '[profiles.main]\n'
          printf 'user_id = "%s"\n' "$(cat "$matrix_user")"
          printf 'url = "%s"\n\n' "$(cat "$matrix_homeserver")"
          printf '[settings]\n'
          printf 'request_timeout = 180\n'
          printf 'username_display = "displayname"\n'
          printf 'read_receipt_display = true\n'
          printf 'read_receipt_send = true\n'
          printf 'typing_notice_display = true\n'
          printf 'typing_notice_send = true\n\n'
          printf '[settings.image_preview]\n'
          printf 'protocol.type = "kitty"\n\n'
          printf '[dirs]\n'
          printf 'downloads = "%s/Downloads/iamb"\n' "$HOME"
        } > "$target"
        chmod 0600 "$target"
      fi
    '';

    file.".config/iamb/private-profile.example.toml".text = ''
      default_profile = "main"

      [profiles.main]
      user_id = "@you:matrix.example.org"
      url = "https://matrix.example.org"

      [settings]
      request_timeout = 180
      username_display = "displayname"
      read_receipt_display = true
      read_receipt_send = true
      typing_notice_display = true
      typing_notice_send = true

      [settings.image_preview]
      protocol.type = "kitty"

      [dirs]
      downloads = "${config.home.homeDirectory}/Downloads/iamb"
    '';

    packages = with pkgs; [
      iamb
      xdg-utils
    ];
  };
}
