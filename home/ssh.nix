{ config, pkgs, lib, ... }:

{
  ########################
  # SSH agent (per-user)
  ########################
  services.ssh-agent = {
    enable = true;
    # Keep it simple – your HM version may not have integration toggles.
  };

  ########################
  # SSH client config
  ########################
  programs.ssh = {
    enable  = true;
    package = pkgs.openssh;

    matchBlocks = {
      "github.com" = {
        hostname       = "github.com";
        user           = "git";

        # Your SSH key
        identityFile   = [ "~/.ssh/id_ed25519" ];
        identitiesOnly = true;

        # Extra raw ssh_config options for this host
        # This becomes:
        #   Host github.com
        #     AddKeysToAgent yes
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
    };
  };
}
