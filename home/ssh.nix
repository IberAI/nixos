{ config, pkgs, lib, ... }:

{
  ########################
  # SSH agent (per-user)
  ########################
  services.ssh-agent = {
    enable = true;
    # No shell-specific integration options – your HM version
    # doesn’t have enableBashIntegration/enableZshIntegration.
  };

  ########################
  # SSH client config
  ########################
  programs.ssh = {
    enable  = true;
    package = pkgs.openssh;

    matchBlocks = {
      # GitHub over SSH
      "github.com" = {
        hostname       = "github.com";
        user           = "git";

        # Your key we fixed earlier
        identityFile   = [ "~/.ssh/id_ed25519" ];
        identitiesOnly = true;

        # Automatically add key to ssh-agent when used
        addKeysToAgent = "yes";
      };
    };
  };
}
