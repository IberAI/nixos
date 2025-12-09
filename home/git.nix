{ config, pkgs, ... }:

{
  # Make sure gpg is available
  programs.gpg = {
    enable = true;
  };

  programs.git = {
    enable  = true;
    package = pkgs.git;

    # Basic identity
    userName  = "IberAI";
    userEmail = "ilteber.dover@gmail.com";

    # Sign all commits with your GPG key
    signing = {
      key = "05AA4F0A904C41E5D4206BFCF167B7A3106DE448";
      signByDefault = true;
    };

    # Handy aliases
    aliases = {
      st   = "status -sb";
      co   = "checkout";
      br   = "branch";
      ci   = "commit";
      df   = "diff";
      lg   = "log --oneline --graph --decorate";
      last = "log -1 HEAD";
    };

    # Extra git config (good sane defaults)
    extraConfig = {
      init.defaultBranch = "main";

      color.ui = "auto";
      diff.colorMoved = "default";

      core = {
        editor   = "nvim";
        autocrlf = "input";
      };

      pull = {
        rebase = true;
        ff     = "only";
      };

      rebase.autoStash = true;

      push = {
        default    = "simple";
        followTags = true;
      };

      merge = {
        ff            = "only";
        conflictStyle = "zdiff3";
      };

      help.autocorrect  = 10;
      credential.helper = "cache --timeout=3600";

      # Use gpg for signing
      gpg.program = "gpg";

      # Also sign tags by default (nice for releases)
      tag.gpgSign = true;
    };
  };
}
