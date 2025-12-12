{ config, pkgs, ... }:

{
  imports = [
    ./settings.nix
    ./profile.nix
    ./policies.nix
  ];

  programs.librewolf = {
    enable  = true;
    package = pkgs.librewolf;

    nativeMessagingHosts = [ pkgs.keepassxc ];
  };
}
