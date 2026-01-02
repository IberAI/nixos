{ config, pkgs, ... }:

{
  # You already have gpg-agent SSH support enabled at the NixOS level:
  # programs.gnupg.agent.enableSSHSupport = true;
  # So skip a separate ssh-agent here to avoid conflicts.

  programs.ssh = {
    enable  = true;
    package = pkgs.openssh;

    # Stop relying on Home Manager's built-in defaults (they're being removed)
    enableDefaultConfig = false;

    matchBlocks = {
      # Your "defaults" (applies to all hosts)
      "*" = {
        extraOptions = {
          AddKeysToAgent = "yes";
          ServerAliveInterval = "60";
          ServerAliveCountMax = "3";
          HashKnownHosts = "yes";
        };
      };

      "github.com" = {
        hostname       = "github.com";
        user           = "git";
        identityFile   = [ "~/.ssh/id_ed25519" ];
        identitiesOnly = true;

        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
    };
  };
}
