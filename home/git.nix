{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    # Basic identity
    userName  = "IberAI";
    userEmail = "ilteber.dover@gmail.com";

    # Optional: extra git config
    # extraConfig = {
    #   init.defaultBranch = "main";
    #   pull.rebase = true;
    #   push.default = "simple";
    # };
  };
}

