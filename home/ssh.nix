{ config, pkgs, lib, ... }:

{
  ########################
  # SSH agent (per-user)
  ########################
  services.ssh-agent = {
    enable = true;

    # Integrate with common shells so SSH_AUTH_SOCK is set
    enableBashIntegration = true;
    enableZshIntegration  = true;
    # enableFishIntegration   = true;
    # enableNushellIntegration = true;
  };

  ########################
  # SSH client config
  ########################
  programs.ssh = {
    enable  = true;
    package = pkgs.openssh;

    # Per-host config
    matchBlocks = {
      # Special rules for GitHub
      "github.com" = {
        hostname       = "github.com";
        user           = "git";
        identityFile   = [ "~/.ssh/id_ed25519" ];
        identitiesOnly = true;

        # Automatically add key to ssh-agent when used
        addKeysToAgent = "yes";
      };
    };
  };
}
