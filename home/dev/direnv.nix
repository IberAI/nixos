{ ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    # enable integrations (safe even if you don’t use all shells)
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
