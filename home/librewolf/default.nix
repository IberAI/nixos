{
  pkgs,
  ...
}:
{
  imports = [
    ./profile.nix
    ./policies.nix
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    nativeMessagingHosts = [ pkgs.keepassxc ];
  };

  home.file.".local/bin/firefox-profile" = {
    text = ''
      #!/usr/bin/env bash
      exec "${pkgs.firefox-bin}/bin/firefox" "$@"
    '';
    executable = true;
  };
}
