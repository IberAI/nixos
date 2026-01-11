{pkgs, ...}: {
  home.packages = with pkgs; [
    # Basic tools (from your list)
    curl
    wget
    zip
    unzip
    p7zip
    htop

    # Shell / CLI extras (from your list)
    lsd
    fastfetch
  ];
}
